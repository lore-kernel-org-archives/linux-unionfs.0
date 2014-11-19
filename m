From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: How to cope with two incompatible overlayfs formats out in the wild
Date: Wed, 19 Nov 2014 09:19:34 +0100
Message-ID: <CAJfpeguf2s1dqFmZe4z=4ucdsC6FpcJSrQSjNw+shPf0uT8LGQ@mail.gmail.com>
References: <CAJfpegtG68g=dDi7j-WfhkuJidZRBg46vyuWg8CTrW3TrW_nYw@mail.gmail.com>
	<20141119015908.GV7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141119015908.GV7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Whitcroft <apw@canonical.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Neil Brown <neilb@suse.de>, linux-unionfs@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Nov 19, 2014 at 2:59 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Nov 18, 2014 at 03:28:03PM +0100, Miklos Szeredi wrote:
>
>> So from mainline we need two things:
>>
>>   - when mounting distinguish between old and new format.
>>
>>   - userspace can detect which formats are supported by the kernel.
>>
>> If we'd have a different filesystem type for the old and new formats,
>> then that would solve both (checking /proc/filesystems would indicate
>> which one is supported).
>>
>> Unfortunately that would mean having to change "overlayfs" type to
>> something else in 3.18.  Question is, is there some sane name which
>> would fit?  "overlayfs2" is perhaps the best, but I'm not overly
>> enthusiastic about it.
>>
>> Any other ideas?
>
> Umm...  What does the old one do when it sees workdir=<something> in the
> options?

Returns EINVAL.

Also the new one will fail without the "workdir=" option, as far as
3.18 is concerned at least.  With the multi layer support work that
option won't be mandatory any more.

But that still doesn't answer the question on how to select the format.

Thanks,
Miklos
