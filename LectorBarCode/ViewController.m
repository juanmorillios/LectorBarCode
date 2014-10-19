//
//  ViewController.m
//  LectorBarCode
//
//  Created by Juan Morillo on 19/10/14.
//  Copyright (c) 2014 Juan Morillo. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.codeDetected = NO;
    [self setupCamera];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}



-(void)setupCamera{
    
    
    //Iniciamos la session de captura de video
    self.session = [[AVCaptureSession alloc]init];
    
    //configuramos como dispositivo de captura la camara de video
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //Configuramos como dispositivo de entrada la camara inicializada
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    [self.session addInput:self.input];
    
    
    // Configuramos como salida la captura de metadatos (para lectura de códigos)
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:self.output];
    
    // Configuramos como tipos de código a detectar, todos los disponibles
    // Es posible unicamente recoger códigos de unos tipos determinados
    self.output.metadataObjectTypes = [self.output availableMetadataObjectTypes];
    
    // Inicializamos una capa de previsualización para poder ver lo que la
    // cámara de video captura
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Lanzamos la sesión de cámara
    [self.session startRunning];
    
    
}



- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // Éste método se ejecuta cada vez que se detecta algún código de los
    // tipos indicados
    
    // Comprobamos que no hayamos detectado un código ya
    if (!self.codeDetected) {
        
        // Recorremos los metadatos obtenidos
        for (AVMetadataObject *metadata in metadataObjects) {
            
            // Recuperamos el valor textual del código de barras o QR
            NSString *code =[(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            
            // Si el código no esta vacío
            if (![code isEqualToString:@""]) {
                
                // Marcamos nuestro flag de detección a YES
                self.codeDetected = YES;
                
                // Mostramos al usuario un alert con los datos del tipo de código y valor
                // detectado en nuestra sesión
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Código detectado" message:[NSString stringWithFormat:@"%@ \n %@",metadata.type,code] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }
        
    }
    
}





-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Éste método se ejecuta cuando el usuario pulsa el botón aceptar
    // en el UIAlertView que le hemos mostrado tras la detección
    // del código de barras o QR.
    
    // Marcamos de nuevo el flag de detección a NO para permitir al
    // usuario leer un nuevo código.
    self.codeDetected = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
