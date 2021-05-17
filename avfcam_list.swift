import AVFoundation

let discovery = AVCaptureDevice.DiscoverySession(
    deviceTypes: [
        AVCaptureDevice.DeviceType.builtInWideAngleCamera,
        AVCaptureDevice.DeviceType.externalUnknown,
    ],
    mediaType: AVMediaType.video,
    position: AVCaptureDevice.Position.unspecified
)

let devices = discovery.devices

//
// All the code below is just for outputting in json format.
//
struct Device: Codable {
    var modelID: String
    var uniqueID: String
    var localizedName: String
    var manufacturer: String
    enum CodingKeys: String, CodingKey {
        case modelID = "spcamera_model-id"
        case uniqueID = "spcamera_unique-id"
        case localizedName = "_name"
        case manufacturer
    }
}

struct DeviceList: Codable {
    var devices: [Device]
    enum CodingKeys: String, CodingKey {
        case devices = "SPCameraDataType"
    }
}

var record = DeviceList(devices: [])

for dev in devices {
    record.devices.append(Device(
        modelID: dev.modelID,
        uniqueID: dev.uniqueID,
        localizedName: dev.localizedName,
        manufacturer: dev.manufacturer
    ))
}

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let data = try encoder.encode(record)
print(String(data: data, encoding: .utf8)!)
