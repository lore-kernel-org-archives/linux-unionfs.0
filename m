Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467B7C4332F
	for <linux-unionfs@archiver.kernel.org>; Sat, 11 Nov 2023 18:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjKKSb1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 11 Nov 2023 13:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjKKSb0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 11 Nov 2023 13:31:26 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4C13861;
        Sat, 11 Nov 2023 10:31:23 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-66d0c777bf0so19525216d6.3;
        Sat, 11 Nov 2023 10:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699727483; x=1700332283; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5gMVOBt0V+vaamhAA+5adS+paoNz2/Vq1LfXO8J20I=;
        b=Wsa1B60uM8LUGSr5izq9E7daAsK1frESiO8rthOFv69gzx4w1PMH1nROiKJm7mZXWe
         noSLrwPOTYOsxlvDTufGgnNZRGKu5tM7IJE2u4yV/4x2oa0K1pFgNxdrXk2BkAk8bHy5
         B1uLmA8NW0/Rxnsco8WHYxxZtTNzUPZQUVCPBBUSXZ5mv1a2ndcT2n/Lcf8bEnfyeiVH
         rOBPVwyZIyWbBCxb5hPRMW7GggCFZMPY7/u3xNXIzw+DeQQT3tN4EtT46w/QaAL3Xyw3
         9d0KgyPLvvDU1qKzWGPgUpn2aasAjaup3D5V5sHtrxjp9LRIjydgh1LMEHH806lvtq7g
         6LqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699727483; x=1700332283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a5gMVOBt0V+vaamhAA+5adS+paoNz2/Vq1LfXO8J20I=;
        b=DHVbODuojLXWqhHzcMEZSEjL1NufGfMoxQ++Wc7CtwrpJ4dh8myU0F1IAq6BjuEpDX
         snSNMNum9xs/dvxunfdJP4frAVGcpzANDVAopUk89jF5AciemMmjBf6RrXKCd+IFO/Bd
         +zCzNTwZrjyj6JsfoKSrOIPG4PWeMQivJnwQFPuS1gFhjHseWr9zCCGrtZ5agW/9sBUF
         UU5m57YQ9oyNIkTUS9cSZ5wKaotJfMaZ3Q7nIVvUN+SfofdTM1AJGb+NrLMfUJbbsFBD
         y/6nPvQsJTVXO3eSyaQphpUEq3vNBQD2KpQNMI1YWb8ifrwDdqfeUkzC9U0c3yOtX8x2
         Y9kg==
X-Gm-Message-State: AOJu0YzZXPmZzx19jphyhDt/03Bi09WHMCiWCkSMPGR2FgOkuqpBwpT6
        4eTz7Nj6KbfkrBPmeuRnjAAU42+QyQR4popOLRACokwP+7c=
X-Google-Smtp-Source: AGHT+IH+heLe++l4FrG2jyqlKzOlikUY2vqLMCg9HOJevWBvd1bN+pmB9O60OO1yyLwy8xf0m4lM2OTr4vvMrj24Oxo=
X-Received: by 2002:ad4:4d08:0:b0:677:91b0:c054 with SMTP id
 l8-20020ad44d08000000b0067791b0c054mr2922194qvl.11.1699727482806; Sat, 11 Nov
 2023 10:31:22 -0800 (PST)
MIME-Version: 1.0
References: <20231111080400.GO1957730@ZenIV>
In-Reply-To: <20231111080400.GO1957730@ZenIV>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 11 Nov 2023 20:31:11 +0200
Message-ID: <CAOQ4uxhQdHsegbwdqy_04eHVG+wkntA2g2qwt9wH8hb=-PtT2A@mail.gmail.com>
Subject: Re: [RFC][overlayfs] do we still need d_instantiate_anon() and export
 of d_alloc_anon()?
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Nov 11, 2023 at 10:04=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
>         AFAICS, the main reason for exposing those used to be the need
> to store ovl_entry in allocated dentry; we needed to do that before it
> gets attached to inode, so the guts of d_obtain_alias() had to be
> exposed.
>
>         These days overlayfs is stashing ovl_entry in the inode, so
> we are left with this:
>         dentry =3D d_find_any_alias(inode);
>         if (dentry)
>                 goto out_iput;
>
>         dentry =3D d_alloc_anon(inode->i_sb);
>         if (unlikely(!dentry))
>                 goto nomem;
>
>         if (upper_alias)
>                 ovl_dentry_set_upper_alias(dentry);
>
>         ovl_dentry_init_reval(dentry, upper, OVL_I_E(inode));
>
>         return d_instantiate_anon(dentry, inode);
>
> ovl_dentry_init_reval() can bloody well be skipped, AFAICS - all it does
> is potentially clearing DCACHE_OP_{,WEAK_}REVALIDATE.  That's also done
> in ovl_lookup(), and in case we have d_splice_alias() return a non-NULL
> dentry we can simply copy it there.  Sure, somebody might race with
> us, pick dentry from hash and call ->d_revalidate() before we notice that
> DCACHE_OP_REVALIDATE could be cleaned.  So what?  That call of ->d_revali=
date()
> will find nothing to do and return 1.  Which is the effect of having
> DCACHE_OP_REVALIDATE cleared, except for pointless method call.  Anyone
> who finds that dentry after the flag is cleared will skip the call.
> IOW, that race is harmless.

Just a minute.
Do you know that ovl_obtain_alias() is *only* used to obtain a disconnected
non-dir overlayfs dentry?

I think that makes all the analysis regarding race with d_splice_alias()
moot. Right?

Do DCACHE_OP_*REVALIDATE even matter for a disconnected
non-dir dentry?

>
> And as for the ovl_dentry_set_upper_alias()... that information used to
> live in ovl_entry until the need to trim the thing down.  These days
> it's in a bit in dentry->d_fsdata.
>
> How painful would it be to switch to storing that in LSB of ovl_entry::__=
numlower,
> turning ovl_numlower() into
>         return oe ? oe->__numlower>>1 : 0
> and ovl_lowerdata() into
>         return lowerstack ? &lowerstack[(oe->__numlower>>1) - 1] : NULL
> with obvious adjustment to ovl_alloc_entry().
>
> An entry is coallocated with an array of struct ovl_path, with
> numlower elements.  More than 2G layers doesn't seem to be plausible -
> there are fat 64bit boxen, but 32Gb (kmalloc'ed, at that) just in
> the root ovl_entry alone feels somewhat over the top ;-)
>
> So stealing that bit shouldn't be a problem.  Is there anything I'm
> missing?

You are missing that the OVL_E_UPPER_ALIAS flag is a property of
the overlay dentry, not a property of the inode.

N lower hardlinks, the first copy up created an upper inode
all the rest of the N upper aliases to that upper inode are
created lazily.

However, for obvious reasons, OVL_E_UPPER_ALIAS is not
well defined for a disconnected overlay dentry.
There should not be any code (I hope) that cares about
OVL_E_UPPER_ALIAS for a disconnected overlay dentry,
so I *think* ovl_dentry_set_upper_alias() in this code is moot.

I need to look closer to verify, but please confirm my assumption
regarding the irrelevance of  DCACHE_OP_*REVALIDATE for a
disconnected non-dir dentry.

Thanks,
Amir.
