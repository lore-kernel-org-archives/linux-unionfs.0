From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs fix for 4.8-rc5
Date: Fri, 9 Sep 2016 22:08:20 +0200
Message-ID: <CAJfpegvMZrF70LgR4hU84GxvvGQ1JcTFMoG1yH78Rh+v2cFuqw@mail.gmail.com>
References: <20160909193709.GO25404@veci.piliscsaba.szeredi.hu> <CA+55aFxX-UbDjL8R1beqP_ZE6-eXJMgnuvPZmJQxA9n-3srEQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxX-UbDjL8R1beqP_ZE6-eXJMgnuvPZmJQxA9n-3srEQQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Sep 9, 2016 at 9:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Sep 9, 2016 at 12:37 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> This fixes a regression caused by the last pull request.
>
> So why are you checking error numbers one by one?
>
> Why is an error not just always an error?

The issue is that not all errors should result in failure.

That code tries to remove ACL from a directory, and there are several cases:

1) success: that's good obviously
2) error: no ACL was found: that's also good
3) error: ACL's are not supported by the filesystem: this is also good
4) error: ACL was there but we failed to remove it for some other
reason: this is not good

The patch adds handling of case 3.

Thanks,
Miklos
