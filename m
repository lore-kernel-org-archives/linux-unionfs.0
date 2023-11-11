Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808E9C4332F
	for <linux-unionfs@archiver.kernel.org>; Sat, 11 Nov 2023 20:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjKKUFa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 11 Nov 2023 15:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjKKUFa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 11 Nov 2023 15:05:30 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41598C7;
        Sat, 11 Nov 2023 12:05:26 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-66d093265dfso19474996d6.3;
        Sat, 11 Nov 2023 12:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699733125; x=1700337925; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=67wUOYLtzzsAuLopJcAHLIEEb3YXBIRYJw8EMjly3n4=;
        b=hmg9gi1Cne01ZKeebtPdsD9UpQ6ZHrn6OEXQj5xuNZMyxhzaOrtfKY6aYqB285/MGV
         BlUvI5ZbIc1f4SiqA/ZhnFXkxH8aBNARTL18ncLrRGg5cKT5YipkdTqA4IYu8egHCJiM
         JO+sCD6fMiEVtDurcSMVAP9wc8zGXA7kZ8ta/0dl9E4PyyOn2wRF5vC+an+2VGvp1ttO
         LCZF8vLIzIo2EdxyBzypxswRVFNXzFtKFM5yCqF28AN1MsfPjy2r/tlozh77KyKjlyuV
         mEa1+LCLX0GVpzaifCKVDogH5yjJ/CYq45jyVbRFt66ghAW4CTw4d/qVQX9L2SJ38b/d
         CFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699733125; x=1700337925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=67wUOYLtzzsAuLopJcAHLIEEb3YXBIRYJw8EMjly3n4=;
        b=XlTMvHmjw+qF7gQjNLkSKTbpzbVKO1SGOWw6GgtwCv/AdlBrjS51b1P69ISLXGgP6P
         4GosxgrqTpTUGv9Ar+z60WmIE4eRFqc3uPN+TkLzNHf0mubFHw6hDli6lIGRKccux84n
         dC955b8B65UfbkFRD5nT6JQ9VTTRnccmLgvoE+Z3lukZDSM5LIeGbqYgkQh91b7kq4iY
         qdc/zF6/8Njxdjoh4P8idBUOnsRYdZiO0b5ptk6bJJiojPTT9yKRyLGQAbiCleU+Y5FB
         ZZmk7MlqtYKi6my6+dYdRWH2LxPhNmEACxZguNn74A59/ccIhYqom+wn+d1pollBEH2t
         8i5A==
X-Gm-Message-State: AOJu0Yzd2PdMMH5fbykaKjvl5CrD1vRaI3UAwT9sSFIurSVt9/nfD27V
        yzZLtcVaZU6kcmFBECI6IsI7UjusQX+bH6/TYv8=
X-Google-Smtp-Source: AGHT+IG478vtG30TF6CSoG2B4dMqHAJu2ziIi9Aw+XdZuzCS+8BupSqSU6utEpHVlk9ggqVYjEJDu8dJ/Q4gwlRlmGQ=
X-Received: by 2002:ad4:5aec:0:b0:66d:37be:47d2 with SMTP id
 c12-20020ad45aec000000b0066d37be47d2mr3938941qvh.37.1699733125370; Sat, 11
 Nov 2023 12:05:25 -0800 (PST)
MIME-Version: 1.0
References: <20231111080400.GO1957730@ZenIV> <CAOQ4uxhQdHsegbwdqy_04eHVG+wkntA2g2qwt9wH8hb=-PtT2A@mail.gmail.com>
 <20231111185034.GP1957730@ZenIV>
In-Reply-To: <20231111185034.GP1957730@ZenIV>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 11 Nov 2023 22:05:14 +0200
Message-ID: <CAOQ4uxjYaHk6rWUgvsFA4403Uk-hBqjGegV4CCOHZyh2LSYf4w@mail.gmail.com>
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

On Sat, Nov 11, 2023 at 8:50=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> On Sat, Nov 11, 2023 at 08:31:11PM +0200, Amir Goldstein wrote:
> > > in ovl_lookup(), and in case we have d_splice_alias() return a non-NU=
LL
> > > dentry we can simply copy it there.  Sure, somebody might race with
> > > us, pick dentry from hash and call ->d_revalidate() before we notice =
that
> > > DCACHE_OP_REVALIDATE could be cleaned.  So what?  That call of ->d_re=
validate()
> > > will find nothing to do and return 1.  Which is the effect of having
> > > DCACHE_OP_REVALIDATE cleared, except for pointless method call.  Anyo=
ne
> > > who finds that dentry after the flag is cleared will skip the call.
> > > IOW, that race is harmless.
> >
> > Just a minute.
> > Do you know that ovl_obtain_alias() is *only* used to obtain a disconne=
cted
> > non-dir overlayfs dentry?
>
> D'oh...
>
> > I think that makes all the analysis regarding race with d_splice_alias(=
)
> > moot. Right?
>
> Right you are.
>
> > Do DCACHE_OP_*REVALIDATE even matter for a disconnected
> > non-dir dentry?
>
> As long as nothing picks it via d_find_any_alias() and moves it somewhere
> manually.  The former might happen, the latter, AFAICS, doesn't - nothing
> like d_move() anywhere in sight...
>
> > You are missing that the OVL_E_UPPER_ALIAS flag is a property of
> > the overlay dentry, not a property of the inode.
> >
> > N lower hardlinks, the first copy up created an upper inode
> > all the rest of the N upper aliases to that upper inode are
> > created lazily.
> >
> > However, for obvious reasons, OVL_E_UPPER_ALIAS is not
> > well defined for a disconnected overlay dentry.
> > There should not be any code (I hope) that cares about
> > OVL_E_UPPER_ALIAS for a disconnected overlay dentry,
> > so I *think* ovl_dentry_set_upper_alias() in this code is moot.
> >
> > I need to look closer to verify, but please confirm my assumption
> > regarding the irrelevance of  DCACHE_OP_*REVALIDATE for a
> > disconnected non-dir dentry.
>
> Correct; we only care if it gets reconnected to the main tree.
> The fact that it's only for non-directories simplifies life a lot
> there.  Sorry, got confused by the work you do with ->d_flags
> and hadn't stopped to ask whether it's needed in the first place
> in there.
>
> OK, so... are there any reasons why simply calling d_obtain_alias()
> wouldn't do the right thing these days?

None that I can think of.

I will try it out and run the tests to see if I have missed something.

Thanks,
Amir.
