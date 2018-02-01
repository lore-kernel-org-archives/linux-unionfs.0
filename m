From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [QUESTION] problem about origin xattr
Date: Thu, 1 Feb 2018 07:37:38 +0200
Message-ID: <CAOQ4uxht44bKgmfJvrLS4XwUvDgameMkr_P_VEsW+TxTS5r+wA@mail.gmail.com>
References: <1594ffa4-1877-0331-d662-bf9e1e0dcca1@huawei.com>
 <CAOQ4uxhGmD2g4Z9EY504OfssyiVvUskKGec0vqraHOHia88PPQ@mail.gmail.com>
 <20180131152041.GA8087@redhat.com> <CAOQ4uxgK+fsRp=gRmQa-9zp8BZFwaJNxTP9ioCg+gOij2G-RCQ@mail.gmail.com>
 <20180131154637.GB8087@redhat.com> <CAOQ4uxgf=Vkq+bikz7eYcFQqvWbyUoucq3UiEZ811Fge=Y2gqg@mail.gmail.com>
 <CAJfpegtpsV+T6kMAVy9+Mr_1kuk4xWUeYaa6MPTzKNjJ28Nq=A@mail.gmail.com>
 <20180131165522.GD8087@redhat.com> <CAJfpegsWhJJdVKi+ZW+5MoYeo87xwtn27sZ2xjExL8-Qk8BPSA@mail.gmail.com>
 <20180131190503.GA2699@redhat.com> <8662e72b-3042-111d-87f0-21e6cc9fd9dc@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:38572 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbeBAFhj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Feb 2018 00:37:39 -0500
Received: by mail-yw0-f178.google.com with SMTP id m84so9541322ywd.5
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 21:37:39 -0800 (PST)
In-Reply-To: <8662e72b-3042-111d-87f0-21e6cc9fd9dc@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: yangerkun <yangerkun@huawei.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Feb 1, 2018 at 5:57 AM, yangerkun <yangerkun@huawei.com> wrote:
>
>
[...]
>>>
>>>
>>> Like directories, we'd only need to set REDIRECT on rename.
>>>
>>> So when file has METACOPY, but not REDIRECT, we just fall through to
>>> next layer below one we are currently operating on.  If we find
>>> METACOPY there, we just continue looking until we find a file
>>> containing the data.
>>>
>>> When we rename or hardlink a file with METACOPY, we add REDIRECT.
>>>
>>> If file has METACOPY and REDIRECT, we follow REDIRECT to find a file
>>> on the next level and keep iterating until we have the one with the
>>> data.
>>>
>>> ORIGIN would not be used in this case.  We might be able to use ORIGIN
>>> for some kind of verification, like we do for directories.   Amir has
>>> a better idea, I think.
>>>
>>> Another way to think about it is: METACOPY is the opposite of OPAQUE.
>>> For directories the default is "metacopy" and contents are merged.
>>> For files the default is "opaque" and content is not merged.  METACOPY
>>> turns that around and enables "merging" of data from a lower layer.
>>> I could even imagine real merging of data, but it's unlikely to be
>>> worth the effort, clone is much better for that; METACOPY is just a
>>> very restricted (and so much simpler) way of merging data.
>>
>>
>> Ok, thanks. I am beginning to understand it better now.
>
>
> Does there any problem using REDIRECT to confirm the file with METACOPY? If
> there is a rename of the REDIRECT file in lower while overlay offline,
> METACOPY will get no file?
>
> I prefer suggestion of Amir, use subtree_check like nfs to make sure the
> origin dentry existing in subdir of the lower layer.
>

This preference depends on the use case.
For your use case that is sensitive to offline lower renames, as well as my
snapshot use case, the chosen behavior could be to follow ORIGIN and fix
REDIRECT to match it, as I implemented here:
https://github.com/amir73il/linux/commits/ovl-redirect-origin

For the default use case where lower content is not expected to change,
but layers could be copied/migrated, relying on file handles is a problem,
so the default would be to follow REDIRECT and verify/fix ORIGIN to match it.

When Vivek implements METACOPY using the same code path used
for directories, the work I did for redirect_dir=origin could be applied
also to METACOPY, given that ORIGIN is changed to use connectable
file handles in that case.

Cheers,
Amir.
