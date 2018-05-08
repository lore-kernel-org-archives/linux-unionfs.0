From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH 00/35] overlayfs: stack file operations
Date: Tue, 8 May 2018 16:25:12 +0200
Message-ID: <CAJfpegtu9AATAJFc-jRfaYZcyvvLKhKti+UsaSQO7BPSP_phvw@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <CAJfpegvnq-+wvmtfX65ts+9eRE-ONGcj6AJyRqhqF1Z=h9bOiA@mail.gmail.com>
 <CAOQ4uxhASo_smS3xXcMP=FD=MCr4g1rpJqkWYbgN6b7AbjeXXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhASo_smS3xXcMP=FD=MCr4g1rpJqkWYbgN6b7AbjeXXg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>, "J. R. Okajima" <hooanon05g@gmail.com>, Ritesh Harjani <riteshh@codeaurora.org>, Matthew Wilcox <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Sat, May 5, 2018 at 6:37 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, May 4, 2018 at 6:23 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Apr 12, 2018 at 5:07 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>>
>>> Git tree is here:
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw
>>
>> Thanks everyone for your review.
>>
>> Force pushed new version to the above branch.
>>
>> Hopefully no comment was missed (I didn't add more reverts yet, those
>> can wait).  I'll do a mailbomb as well next week and start processing
>> the metacopy patches.
>>
>
> Ran -g auto xfstests on overlay over xfs+reflink.
> There are no failures and no changes w.r.t skipped tests since v4.17-rc1.
>
> ACK on w.r.t addressing my review comments.
>
> ACK on the freeze protection fix.
> Not sure if the fact that we take __mnt_want_write() on overlay and not on
> upper_mnt for ovl_real_ioctl() is a problem (i.e. can upper_mnt become
> readonly from under overlay? and do we care?).

I don't think we care.  The mount part of the real path doesn't play a
very important part because it's private to the overlay and it's never
modified.  It would be interesting to dig into the places it is used
(may not be necessary in all cases), but that's for later.

Thanks,
Miklos
