From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlay filesystem fixes for 3.18
Date: Fri, 21 Nov 2014 13:41:57 +0100
Message-ID: <CAJfpegtRktN8BdOogCMW++Gar02j06K=9OYOyDMBbwBZq6_=Hg@mail.gmail.com>
References: <20141120164531.GB3596@tucsk>
	<1962959.JkOx4gJGaG@xrated>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1962959.JkOx4gJGaG@xrated>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 21, 2014 at 12:32 PM, Hans-Peter Jansen <hpj@urpla.net> wrote:
> Dear Miklos,
>
> On Donnerstag, 20. November 2014 17:45:31 Miklos Szeredi wrote:
>>
>> The biggest change is to rename the filesystem from "overlayfs" to
>> "overlay". This will allow legacy overlayfs to be easily carried by distros
>> alongside the new mainline one.
>
> Would you kindly give a firm elaboration of this rename?
>
> Why would a distro kernel maintainer want to keep the external overlayfs
> patches together with the now in kernel module?
>
> Isn't it enough to drop the external patches from distro kernels in order to
> use it successfully or are there any semantic changes hidden that an admin
> should know about?

See this thread:

https://lkml.org/lkml/2014/11/18/433

Thanks,
Miklos
