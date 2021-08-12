#include <iostream>
#include <string>
#include <unistd.h>
#include <CommonAPI/CommonAPI.hpp>
#include <v0/commonapi/TpOverUdpTestProxy.hpp>

using namespace v0::commonapi;

int main() {
    std::shared_ptr < CommonAPI::Runtime > runtime = CommonAPI::Runtime::get();
    //std::shared_ptr<TpOverUdpTestProxy<>> myProxy = runtime->buildProxy<TpOverUdpTestProxy>("local", "test", "hello_world_client");
    std::shared_ptr<TpOverUdpTestProxy<>> myProxy = runtime->buildProxy<TpOverUdpTestProxy>("local", "Server.server", "hello_world_client");

    // START modification
    // I ran into a NULL myProxy on older versions (possibly a version
    // mismatch).  Instead of segfaulting, let's note it here.  This is the
    // only change compared to the original "10 minutes" example
    if (!myProxy)
    {
       std::cerr << "HelloWorldClient FAIL: Returned  proxy is NULL! - Giving up!\n";
       return 2;
    }
    // END modification

    std::cout << "Checking availability!" << std::endl;
    while (!myProxy->isAvailable())
        usleep(10);
    std::cout << "Available..." << std::endl;

    CommonAPI::CallStatus callStatus;
    //std::string returnMessage;
    bool returnMessage;
    myProxy->sayHello("Bob", callStatus, returnMessage);
    std::cout << "Got message: '" << returnMessage << "'\n";

    return 0;
}

