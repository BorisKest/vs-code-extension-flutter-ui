export interface FlutterMessage {
    type: string;
    message: string;
    timestamp?: string;
}

export interface FlutterCommand {
    action: string;
    text?: string;
    command?: string;
    [key: string]: any;
}

export interface ExtensionResponse {
    type: string;
    message: string;
    data?: any;
}
