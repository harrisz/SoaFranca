#ifndef HELLOWORLDSTUBIMPL_H_
#define HELLOWORLDSTUBIMPL_H_

#include <CommonAPI/CommonAPI.hpp>
#include <v0/commonapi/TpOverUdpTestStubDefault.hpp>

class HelloWorldStubImpl: public v0::commonapi::TpOverUdpTestStubDefault {
public:
    HelloWorldStubImpl();
    virtual ~HelloWorldStubImpl();
    virtual void sayHello(const std::shared_ptr<CommonAPI::ClientId> _client, std::string _name, sayHelloReply_t _return);
};

#endif /* HELLOWORLDSTUBIMPL_H_ */
