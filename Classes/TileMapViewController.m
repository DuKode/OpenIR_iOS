//     File: TileMapViewController.m
// Abstract: 
//     View controller to display a raster tiled map overlay on an MKMapView.  Demonstrates how to use the TileOverlay and TileOverlayView classes with MKMapView.
//   
//  Version: 1.0
// 
// Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
// Inc. ("Apple") in consideration of your agreement to the following
// terms, and your use, installation, modification or redistribution of
// this Apple software constitutes acceptance of these terms.  If you do
// not agree with these terms, please do not use, install, modify or
// redistribute this Apple software.
// 
// In consideration of your agreement to abide by the following terms, and
// subject to these terms, Apple grants you a personal, non-exclusive
// license, under Apple's copyrights in this original Apple software (the
// "Apple Software"), to use, reproduce, modify and redistribute the Apple
// Software, with or without modifications, in source and/or binary forms;
// provided that if you redistribute the Apple Software in its entirety and
// without modifications, you must retain this notice and the following
// text and disclaimers in all such redistributions of the Apple Software.
// Neither the name, trademarks, service marks or logos of Apple Inc. may
// be used to endorse or promote products derived from the Apple Software
// without specific prior written permission from Apple.  Except as
// expressly stated in this notice, no other rights or licenses, express or
// implied, are granted by Apple herein, including but not limited to any
// patent rights that may be infringed by your derivative works or by other
// works in which the Apple Software may be incorporated.
// 
// The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
// MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
// THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
// OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
// 
// IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
// OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
// MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
// AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
// STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// 
// Copyright (C) 2010 Apple Inc. All Rights Reserved.
// 

#import "TileMapViewController.h"
#import "TileOverlay.h"
#import "TileOverlayView.h"
#import "WildcardGestureRecognizer.h"

@implementation TileMapViewController

- (void)viewDidLoad
{
    // an instance of WildcardGestureRecognizer is for recognizing touches in the MKMapKit  
    tapInterceptor = [[WildcardGestureRecognizer alloc] init];
    tapInterceptor.touchesBeganCallback =^(NSSet * touches, UIEvent * event) {
        NSLog(@"TOUCH BEGAN IN VIEWCONTROLLER\n");
        [map removeOverlays:map.overlays];
        if (currentview == 432) {
            [map addOverlay:overlay_321];
            currentview = 321;
        }
        else {
            [map addOverlay:overlay_432];
            currentview = 432;
        }
    };
    [map addGestureRecognizer:tapInterceptor];
    
    // Initialize the TileOverlay with tiles in the application's bundle's resource directory.
    // Any valid tiled image directory structure in there will do.
    NSString *tileDirectory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Tiles"];
    overlay_321 = [[TileOverlay alloc] initWithTileDirectory:tileDirectory];
    
    //arlduc: add a second band combination
    NSString *tileDirectory2 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Tiles_432"];
    overlay_432 = [[TileOverlay alloc] initWithTileDirectory:tileDirectory2];
    [map addOverlay:overlay_432];
    currentview = 432;
    NSLog(@"ADDED 432\n");

    
    
    // zoom in by a factor of two from the rect that contains the bounds
    // because MapKit always backs up to get to an integral zoom level so
    // we need to go in one so that we don't end up backed out beyond the
    // range of the TileOverlay.
    MKMapRect visibleRect = [map mapRectThatFits:overlay_321.boundingMapRect];
    visibleRect.size.width /= 2;
    visibleRect.size.height /= 2;
    visibleRect.origin.x += visibleRect.size.width / 2;
    visibleRect.origin.y += visibleRect.size.height / 2;
    map.visibleMapRect = visibleRect;
}





- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    TileOverlayView *view = [[TileOverlayView alloc] initWithOverlay:overlay];
    view.tileAlpha = 1;
    
    return [view autorelease];
}



#pragma mark === Touch handling  ===
#pragma mark


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[tapInterceptor touchesBeganCallback];
    
    NSLog(@"TOUCH BEGAN IN VIEWCONTROLLER\n");
    [map removeOverlays:map.overlays];
    if (currentview == 432) {
        [map addOverlay:overlay_321];
        currentview = 321;
    }
    else {
        [map addOverlay:overlay_432];
        currentview = 432;
    }
    
    
}


// Handles the start of a touch
/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"TOUCH BEGAN\n");
    [map removeOverlays:map.overlays];
    if (currentview == 432) {
        [map addOverlay:overlay_321];
        currentview = 321;
    }
    else {
        [map addOverlay:overlay_432];
        currentview = 432;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"TOUCH ENDED\n");
}
*/
 
- (void)dealloc
{
    [overlay_321 release]; 
    [overlay_432 release]; 
    [tapInterceptor release];
}


@end
