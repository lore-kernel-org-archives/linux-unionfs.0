From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [GIT PULL] overlayfs update for 4.9
Date: Fri, 14 Oct 2016 13:10:52 +0300
Message-ID: <CAOQ4uxivR5O2iORjhW008=eGmuSZQekOi1H+bmiM0NCnEw2o6Q@mail.gmail.com>
References: <20161013143751.GE31239@veci.piliscsaba.szeredi.hu>
 <CA+55aFyEtF-t5rbbOtAz1+Rdxcbbt+CTrWJWPg1+TViq+DoLCQ@mail.gmail.com> <CAOQ4uxiSMVfUG7mVT6WC2eBtF-XOSM1WrSBnxo0Dkr1fy=ZJeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxiSMVfUG7mVT6WC2eBtF-XOSM1WrSBnxo0Dkr1fy=ZJeg@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 14, 2016 at 9:48 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Oct 14, 2016 at 7:03 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, Oct 13, 2016 at 7:37 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>
>>> Please pull from:
>>
>> No.
>>
>> Or rather, I pulled and then immediately unpulled. When I look at the
>> diff, I saw an obvious bug in the very first chunk. I'm not going to
>> pull something that is this obviously buggy and untested.
>>
>> Your change to fs/ioctl.c to add a -EXDEV error case very clearly
>> leaks a reference to 'src_file'.
>
> On the charge of writing obviously buggy code I plead guilty :-/
> On the charge of not testing my code I plead not guilty.
> I exercised the FICLONERANGE intensively with the xfstests clone test group
> and never experienced any problem and any warning running with all
> relevant kernel debugging enabled.
>
> So how come this leak went unnoticed?
> Because fdget (__fget_light) does not take a reference if the fd is not shared.
>
> So what can we do to catch silly mistakes like this one earlier and
> without relying
> on Linus's spidy senses?
> Writing xfstests to test all fd interfaces with cloned fds? Is this a
> scalable solution?


Well, I added an idle loop thread to xfs_io and sure enough it catches the leak
in test generic/157 (Try cross-device reflink).
I will post patches to fstests.

Sorry...

> Or maybe it's best to add a trivial CONFIG_DEBUG_FDGET that will always
> skip the no refcount optimization?
>
> To me the second option seems preferred from engineering pov
> I can post this simple patch if you guys agree to this solution.
>
>>
>> It's too late in the merge window for this to be fixed up any more.
>> This has been a painful enough merge window for me that I'm not going
>> to play around with obviously buggy pull requests.
>>
>
> It has been a rocky merge window and I apologize for adding this last straw
> and pooping the party for the entire overlay pull request.
> In the hope that this may help to sweeten your verdict -
> I just got my hands on a brand new testing machine, which is dedicated
> to stress testing file systems on the latest rc.
>
> Amir.
>
>>                   Linus
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
