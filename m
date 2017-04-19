From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 03/13] ovl: lookup redirect by file handle
Date: Wed, 19 Apr 2017 18:35:21 +0300
Message-ID: <CAOQ4uxgayetEutPuREuzWRJiMDtXucLEBkahw1Ae27dZPotTXw@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <1492387183-18847-4-git-send-email-amir73il@gmail.com> <20170418130554.GB9056@redhat.com>
 <CAOQ4uxi2a3K-a2A2RghSsJxf7QEP8Mcb4P_dyygYq=eggAi8SQ@mail.gmail.com>
 <20170418183204.GE9056@redhat.com> <CAOQ4uxgqTs3HmX_VaTCjJX80hJR-UOn1K1R2jHw_TOHOON9wUg@mail.gmail.com>
 <CAJfpegtWnCrdecWu1ivXRiy86f_u+=mCb3g1zpEqRZwGp9W=QA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35578 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764426AbdDSPfX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 11:35:23 -0400
In-Reply-To: <CAJfpegtWnCrdecWu1ivXRiy86f_u+=mCb3g1zpEqRZwGp9W=QA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Apr 19, 2017 at 6:21 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Apr 18, 2017 at 8:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Tue, Apr 18, 2017 at 9:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> On Tue, Apr 18, 2017 at 05:05:12PM +0300, Amir Goldstein wrote:
>>>
>>> [..]
>>>> > (This ovl_lookup() logic has become really twisted now. I wished it was
>>>> >  little easier to read.)
>>>> >
>>>>
>>>> Me too. IMO, most of the complexity is in the fallbacks from redirect
>>>> by fh to full path to relative path. Eliminating some of these fallbacks
>>>> and maybe having separate lookup op per mode, may simplify the code.
>>>
>>> In general, why are we falling back to path based lookup. If lower dirs
>>> were copied or something else, that's a configuration error and overlayfs
>>> will have undefined behavior?
>>>
>>
>> Heh, I just sent out a summary of what happens when lower dirs are copied.
>> The fallback is needed because when lower/upper dirs are copied
>> (which is a perfectly valid practice), the xattr are copied with them.
>> So the fallback is needed because ovl_lookup() find the fh on upper dir
>> and tries to follow it only to realize that it is stale - then it assumes that
>> layers were copied and resorts to path lookup.
>>
>> My point earlier is that I wish to move this "was I copied?" test to mount
>> time instead of doing it on every lookup. But then user won't be able
>> to enjoy all the benefits of stable inodes after layers were copied, so
>> this is not ideal.
>
> How so?  Nobody is expecting the copy to have the same inode numbers
> as the original.
>
> So it's fine if the relation to the original lower layer file is
> broken, we don't care about that anymore.  Except for the hard link
> case, but that relation can be preserved in the reverse mapping.
>

I was addressing Vivek's concern about the complexity of the
"fallback from fh to path" code.
I managed to get the following use case wrong:
- 2 or more lower layers that have some dir redirects by path
- upper layer that now creates redirect_fh
After following from upper to lower1 by fh, I failed to follow by
path to lower2.

So I contemplated detecting this mixed mode at mount time
and disabling redirect_fh.

Nevermind, I'll just fix the fallback in mid layers case.
