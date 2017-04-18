From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 03/13] ovl: lookup redirect by file handle
Date: Tue, 18 Apr 2017 21:57:29 +0300
Message-ID: <CAOQ4uxgqTs3HmX_VaTCjJX80hJR-UOn1K1R2jHw_TOHOON9wUg@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <1492387183-18847-4-git-send-email-amir73il@gmail.com> <20170418130554.GB9056@redhat.com>
 <CAOQ4uxi2a3K-a2A2RghSsJxf7QEP8Mcb4P_dyygYq=eggAi8SQ@mail.gmail.com> <20170418183204.GE9056@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35612 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbdDRS5b (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2017 14:57:31 -0400
In-Reply-To: <20170418183204.GE9056@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Apr 18, 2017 at 9:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Apr 18, 2017 at 05:05:12PM +0300, Amir Goldstein wrote:
>
> [..]
>> > (This ovl_lookup() logic has become really twisted now. I wished it was
>> >  little easier to read.)
>> >
>>
>> Me too. IMO, most of the complexity is in the fallbacks from redirect
>> by fh to full path to relative path. Eliminating some of these fallbacks
>> and maybe having separate lookup op per mode, may simplify the code.
>
> In general, why are we falling back to path based lookup. If lower dirs
> were copied or something else, that's a configuration error and overlayfs
> will have undefined behavior?
>

Heh, I just sent out a summary of what happens when lower dirs are copied.
The fallback is needed because when lower/upper dirs are copied
(which is a perfectly valid practice), the xattr are copied with them.
So the fallback is needed because ovl_lookup() find the fh on upper dir
and tries to follow it only to realize that it is stale - then it assumes that
layers were copied and resorts to path lookup.

My point earlier is that I wish to move this "was I copied?" test to mount
time instead of doing it on every lookup. But then user won't be able
to enjoy all the benefits of stable inodes after layers were copied, so
this is not ideal.

I guess what we could do is disable the redirect_dir by fh optimization
for directories if layers were copied and always follow non-dirs by fh.
That will eliminate the fallback and none of the stable inode features
would miss anything.
This should work well with the copied layers use case.

Amir.
