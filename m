Return-Path: <vgoyal@redhat.com>
Date: Tue, 9 Jul 2019 10:13:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] unionmount metacopy tests
Message-ID: <20190709141302.GA19084@redhat.com>
References: <CAOQ4uxhi63LPKdmkEJjnTEgy0VaX0qXML2Uz_258_B2iZcqd3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhi63LPKdmkEJjnTEgy0VaX0qXML2Uz_258_B2iZcqd3w@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Jul 04, 2019 at 06:11:25PM +0300, Amir Goldstein wrote:
> Hi Vivek,
> 
> I was working on extending snapshot validation tests and got
> this as a by-product:
> 
> https://github.com/amir73il/unionmount-testsuite/commits/metacopy
> 
> ca566c3 Check that data was not copied up with metacopy=on
> 140d99c Reset dentry copy_up state on upper layer rotate
> 960a5ce Check that files were copied up as expected
> 1bfcc7d Record meta copy_up vs. data copy_up
> c3db453 Fix instantiation of hardlinked dentry
> 2104e51 Simplify initialization of __upper
> 1fc2eec Fix ./run --ov --verify --recycle
> 
> Would you be interested to review these changes,
> so I would merge them to master?

Hi Amir,

Glad to see more tests for metacopy feature. I will have a look at
these.

> 
> Would you or someone else be interested in running those tests
> regularly on pre release kernel?

I generally don't run tests regularly on latest kernel. Whenever I 
am fixing something, I run tests to make sure I have not broken
anything.

So I can't say I will run the tests regularly, but once in a while
I should be able to run it.


> 
> If anyone is running unionmount-testsuite on regular basis
> I would be happy to know which configurations are being tested,
> because the test matrix grew considerably since I took over the project -
> both Overlayfs config options and the testsuite config options.

For me, I think I am most interested in configuration used by
container runtimes (docker/podman). Docker seems to turn off
redirects as of now. podman is turning on metacopy (hence redirect)
by default now to see how do things go.

So for me (redirect=on/off and metacopy=on/off) are important
configurations as of now. Havind said that, I think I should talk
to container folks and encourage them to use "index" and "xino"
as well to be more posix like fs.

I think container folks still have not modified their code to
be able to generate an image layer properly if redirect is
enabled. Last time Miklos had some good ideas. I will poke them
again. It will be nice if they can use redirect (instead of
disabling it) and be able to generate image layer efficiently. 

Thanks
Vivek
