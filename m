Return-Path: <linux-unionfs+bounces-1-linux-unionfs=archiver.kernel.org@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82121C54E76
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Nov 2023 23:03:24 +0000 (UTC)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3897528194A
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Nov 2023 23:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE0683AC0C;
	Mon, 20 Nov 2023 23:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="XjiUeyqL"
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03F5C1
	for <linux-unionfs@vger.kernel.org>; Mon, 20 Nov 2023 15:03:19 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-da41acaea52so4633754276.3
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Nov 2023 15:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1700521399; x=1701126199; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lcx1O4WZkW9lPEGbS1WuKh9uKwQmfhNTK/5zQiqlRjM=;
        b=XjiUeyqLN45Ith9i1sl9lpw3NhEIaYMXdFn+Qd4VwL5PoivCVxWuYveMsOG+Io09SI
         lEQ3eTXh3fPrEjLL+xngRjjAPSd/FcHv1MRGWtXTJh8VHquVqMP2QKtk2NDqVoLhYq/Q
         UZjRRn1ofQ93T1gLxAVoSPdv7ohLEgv8h7y2FRq9/cRvvdUeK2t07HtG+dNuMlLttE4w
         ShlzyxTkxlN+R7jtLboV3HpSL7A4G0Ccjl0we+2d7du84TkYKJhhSFkdS/CaG62nqRGI
         IY4eYLOJq2nGT0PqOdg7qfcqKPcq4Dq4zbzixTgs7+6GnQ7QBmvLHcMAYOkuiBRv8nDl
         NZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700521399; x=1701126199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lcx1O4WZkW9lPEGbS1WuKh9uKwQmfhNTK/5zQiqlRjM=;
        b=f6wXVCxykoaBmm91TKl/TQy4A7GfKU6wkfZot+g+UuMZaTRA8RB2MDcwKknkTZsXaN
         K+wzkOYr11rx0aII/4d7OaYxYTy+RJsx04v6Qda/RjK/x4hkII/EhHGwOF+oYnfQL/Tq
         njMa8SPZQtsSTuepevuZga3Q9LvfpIseCWrZzSW4ZXQ18zc6xKabYDKqimLGfRs1bHpR
         Prigueos4e0URwbpy66orVuJ2gWzQtOjXc5RddjZ1ASqr+bBI+kkV597t8iTTnNqZrdQ
         8e/FyPIQRwWASY9/AcjinBZQo4hETaCUlHZKRT8fRp3wS/q7k1iodrFOysZxJoWlGtqx
         DOTA==
X-Gm-Message-State: AOJu0YxVoW2qfISfrWHaY2NPnZpcoGgNmZUZKZs8j0xFrBP8Ofj5d3yg
	dKy0Z3iBBQTQl1t5JQxm3M7SDXHnZrkiN/pPO+Yn
X-Google-Smtp-Source: AGHT+IEj/EkYlF2Cfty/fg0eKdElXPWPH5PHzzR4nbrd5O5pXcFkWDSd0Gz1dQZM82iONs/wFeJ0H0cTf0AW1mJ1DjQ=
X-Received: by 2002:a25:ab30:0:b0:da0:66ed:ea1e with SMTP id
 u45-20020a25ab30000000b00da066edea1emr8782208ybi.11.1700521399032; Mon, 20
 Nov 2023 15:03:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231018100815.26278-1-ddiss@suse.de> <CAEjxPJ6o8T=K+FHEHdWxn1PQN=Ew+KjooXL=coS0gx4YLuEFhw@mail.gmail.com>
 <CAHC9VhTLjcQXNoc8L3Uw=TRRghLuA_TnQbRkGtwnCu4kxVXE0g@mail.gmail.com> <20231020223327.09a6a12b@echidna.fritz.box>
In-Reply-To: <20231020223327.09a6a12b@echidna.fritz.box>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 20 Nov 2023 18:03:08 -0500
Message-ID: <CAHC9VhTh-2TfE+0Kb551E=Ld0TwER=-N+mkr2R=122TbNvcHRw@mail.gmail.com>
Subject: Re: [PATCH] RFC: selinux: don't filter copy-up xattrs while uninitialized
To: David Disseldorp <ddiss@suse.de>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>, selinux@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 20, 2023 at 4:33=E2=80=AFPM David Disseldorp <ddiss@suse.de> wr=
ote:
>
> Hi Paul and Stephen,
>
> On Fri, 20 Oct 2023 11:55:31 -0400, Paul Moore wrote:
>
> > On Fri, Oct 20, 2023 at 8:21=E2=80=AFAM Stephen Smalley
> > <stephen.smalley.work@gmail.com> wrote:
> > > On Wed, Oct 18, 2023 at 6:08=E2=80=AFAM David Disseldorp <ddiss@suse.=
de> wrote:
> > > >
> > > > Extended attribute copy-up functionality added via 19472b69d639d
> > > > ("selinux: Implementation for inode_copy_up_xattr() hook") sees
> > > > "security.selinux" contexts dropped, instead relying on contexts
> > > > applied via the inode_copy_up() hook.
> > > >
> > > > When copy-up takes place during early boot, prior to selinux
> > > > initialization / policy load, the context stripping can be unwanted
> > > > and unexpected. Make filtering dependent on selinux_initialized().
> > > >
> > > > RFC: This changes user behaviour so is likely unacceptable. Still,
> > > > I'd be interested in hearing other suggestions for how this could b=
e
> > > > addressed.
> > >
> > > IMHO, this is fixing a bug, only affects early userspace (pre policy
> > > load), and is likely acceptable.
> > > But Paul will make the final call. We can't introduce and use a new
> > > policy capability here because this is before policy has been loaded.
> >
> > I agree with Stephen, this is a bug fix so I wouldn't worry too much
> > about user visible behavior.  For better or worse, the
> > SELinux-enabled-but-no-policy-loaded case has always been a bit
> > awkward and has required multiple patches over the years to correct
> > unwanted behaviors.
>
> Understood.
>
> > I'm open to comments on this, but I don't believe this is something we
> > want to see backported to the stable kernels, and considering we are
> > currently at v6.6-rc6, this isn't really a candidate for the upcoming
> > merge window.  This means we have a few more weeks to comment, test,
> > etc. and one of the things I would like to see is a better description
> > of before-and-after labeling in the commit description.  This helps
> > people who trip over this change, identify what changed, and helps
> > them resolve the problem on their systems.
> >
> > Does that sound good?
>
> That sounds good to me. I'll rework the commit description (and comment
> above this change), do some further testing and then submit a v2.

Hi David,

No rush, I just wanted to check in on this and see how things were going?

--=20
paul-moore.com

