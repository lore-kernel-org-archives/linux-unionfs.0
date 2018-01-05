From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 06/23] ovl: add support for "verify" feature
Date: Fri, 5 Jan 2018 22:37:49 +0200
Message-ID: <CAOQ4uxhfPLUjVWJ0gbcn_3jnddtvmJvPLo3YkuX6CYVwB_gz=w@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-7-git-send-email-amir73il@gmail.com> <20180105154323.GC29480@redhat.com>
 <CAOQ4uxg35sutZZUCKQxoiuNVfLXxe44wavX95bC_GMntbLn-QQ@mail.gmail.com>
 <20180105163951.GF29480@redhat.com> <CAOQ4uxi_F5Zpd_NZuJU2MCKP73jCVfKJWb9GQ6TNkSWxbcEBWg@mail.gmail.com>
 <20180105190729.GH29480@redhat.com> <CAOQ4uxhX7xSayQ_eUfzoi_7wGyEik6D4aCLFpZJMtTRc=RvUVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:37849 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbeAEUhv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 15:37:51 -0500
Received: by mail-yw0-f174.google.com with SMTP id v190so2214362ywg.4
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Jan 2018 12:37:50 -0800 (PST)
In-Reply-To: <CAOQ4uxhX7xSayQ_eUfzoi_7wGyEik6D4aCLFpZJMtTRc=RvUVA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 5, 2018 at 10:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Jan 5, 2018 at 9:07 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
[...]
>>> Those are good questions to address to Miklos.
>>> In V1, the mount option was called 'index=all' for indexing every file/dir
>>> on copy up and the verify origin functionality was implemented with
>>> a different option (verify_dir).
>>> Then I realized that full indexing could actually be a feature on its own,
>>> so I named this feature and documented what it does in Kconfig.
>>
>> index=all was much more intuitive to me. I could understand that it will
>> create index for all kind of objects (and not just hardlinks).
>>
>
> Yes, it was straight forward to understand technically, but what does it
> say to users? absolutely nothing. OTOH redirect_dir is not called
> dir_rename, so yeh, index=all can work.
> Whatever Miklos prefers is fine by me.
>
>>>
>>> Another option name I was contemplating is 'redirect_dir=verify'
>>> this name makes a lot more sense for the part of detecting multiple
>>> redirects.
>>
>> Or verify_redirect_dir=on/off. Advantage of fine grained options is
>> that user can opt-in. But at the same time too many options will be
>> confusing.
>
> The reason I like 'redirect_dir=verify' is because redirect_dir already has
> modes now and those modes are not going to be a complex matrix of
> options, just a linear scale of options: off,follow,on,verify
> which are relatively easy to document.
>
> So maybe the most logical thing to do is to add redirect_dir=verify to
> control the new behavior of verifying merge dir and detecting multiple redirect
> and add an option index=all to control full indexing and detecting multiple
> origin of non-dir. And either let redirect_dir=verify imply and turn on
> index=all or let redirect_dir=verify require index=all and fail mount.
>
> How do you feel about this option?
>
>>
>>> The reason I went for the more generic name 'verify=on' is because the
>>> feature also detects multiple files with same origin (which are not hardlinks).
>>
>> So one problem with verify=on is that say it checks for 3 inconsistencies
>> today. What will happen when we check for 4th inconsistency tomorrow. Say
>> we want to enforce ORIGIN validity on non-dir objects. If we combine it
>> with verify=on, then it becomes a backward copatibility issue. If we
>> come up with a separate option, then we kind of split it badly. That is
>> non-dir origin verification has separate mount option while dir origin
>> verification is part of verify=on.
>>
>> Atleast a normal user will find it very hard to figure it out.
>>
>>> I have no strong feelings about the verify=on feature name.
>>
>> I don't have strong feelings either. I am just trying to think from a
>> user's point of view and also thinking what will happen when more
>> inconsistency checks are added in future. Will these be part of verify=on
>> or we will create new options due to backward compatibility concerns.
>>
>
> I understand your concern.
> I agree that verify=on sounds a bit too broad and inviting trouble ;-)
>

But I just remembered why I switched from 2 opt-in mount options in V1
to a single config/module option in V2. consistency verification as well
NFS export don't play well with overlays that are mounted without full
index, so I wanted to have a config option that would make NFS export
"just work" with overlayfs if default mount options are used.

I guess I could have OVERLAY_FS_INDEX_ALL as a config option
that depends on OVERLAY_FS_INDEX and redirect_dir=verify as
a mount option.

Or, I could follow you advise and just rename OVERLAY_FS_VERIFY
to OVERLAY_FS_VERIFY_ORIGIN, which implies both full index
and verification of lower dir.

That last option is my favorite at the moment.

How about it?

Amir.
