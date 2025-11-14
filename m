Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8328713AF2
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 10:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115978; cv=none; b=ui7BnsR4AGgT9dDpYC/m15iN94xbdLGu5D6xR19TRD4lU7zooeKcz0pIbkQcmj5vi/3sAh8E/Synhef6Azrylr2CsorMSuEMiPoF8rmkyVPfmqTgbNWsjdMMjHJAtFISnLIHWQcZ4dkqAb2Y2RthU5VPinquW9+2TwiY8jkOREI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115978; c=relaxed/simple;
	bh=Fe4+q7Knka7qKfvvXEjqGoG4VtSNdAANJNsKClnoq1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GGA0EOgeu4pgGdRCZ8UkvSqbRxgA0GTiHgsfMzn6jk3VzutRfRTjQcSCbh51/HEGnP8nUm1+O4f/NAnqWI8QN02Lr1cCxoVsYrIL83mGOmdHJGaRK5o8d3vF2/d1FBnpGsY8R5Wxc3uySC1y4hUusM9j+BJqxRpscM+Z6joRbD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iSvW3jSC; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSvW3jSC"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6408f9cb1dcso2700589a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 02:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763115975; x=1763720775; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M919p6rjN1bXEXYx263WtyltECG5QWhuVC76Ko6AMW0=;
        b=iSvW3jSCX5EB/zx2pgMldifzWl2HIuFlO3c8l3EplHqabysO7w/PXjA3KEqJI0B84X
         Cj8I3waPl6GPF501G5UujWWpIed0izNN+Z/aAOoJaMvk6PxiOEbuQHPqReHaiNLd5Fxz
         +hoxYm+U4+0bxnW3wReMvnh/HjEF19OLGy7tvEH51TMML3vmXwMS8z0UqDShHUoj3eSu
         NX/Jdg+rOmIrhpBkAebWtv9NteFjFfYupuRzK2Z9cYkvRjYAYAc72qicEUiRh4XTWhju
         C/gPPgR0AQNf98ilmCmtUmzvuqLu8sqAl+uQj7HnwxD5SIFX+m13mLXY6rDLFRCstIIX
         zolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763115975; x=1763720775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M919p6rjN1bXEXYx263WtyltECG5QWhuVC76Ko6AMW0=;
        b=XZqb4ouWo20dkrQ9KHlRE9aTMnW35mZqxEUeODqgoA5yMNI7lVPu1X1QF5l2Cqu/cx
         oW4BuaVMREjvilsjWlv6D/StbYyhi5V5oJHzhHaqIpA9suMe3LbxxeByjIfDQ5QbJxvZ
         HVFFPszvmvDfORZyusIqjZqGiVupWGs0b3QofF8KPMpTo5sPTOHW3Snr9uL7mDnAwQTA
         IscMlaqkRlXmTAvTp2JAMIJqtU4rkVtuiK754GF8TVq8HoWHydqdz1enRos4UNVo0PjB
         URU73hhNVxESPRN8BIf7rMZP3Df8EIM/Y/jTyJYE43r3uGCOkfD8BLYoowou37FZVLgS
         bmQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfAutPOwkKij9Zsdd5SiJB6FEh7ZSslBksO1OxfgVjzQc1iqrNmsU95IBK/OoZ3ZsKWWz5yXnqAirwrJPw@vger.kernel.org
X-Gm-Message-State: AOJu0YwYXTPhkfUvmgWT52BfS9il2QKOyNyIv0WNjpp8B1LkyhFHZS3D
	ZkLumxqb3g5k1IGEIiTRE4igUYteCB76HreIa0Cf0v3Qb6gNObmla3NLnZjRLGzvOGe5aZmk24E
	Zl71xqVgFn0mQF9mYiF2TpaZHE8YG/bI=
X-Gm-Gg: ASbGnctWnBWaqqmkygcgo7xVvAOBXhsElwHS95+PT0aCucfzZ+jUnQdX4RzgQNnb0zf
	R1tDHKpNjsH2qaH6Ppao5wjZzphPGU9KGitzhx7yIk+iuV8sDaYhm2wi2XmuWRJ7L/xzQyxNWsx
	5+ExvD8FlnJhbxisqfhi9rwn9Osp9gfsRi5CoXDMneEGepwyOv4Y0hqlmS3mC496UPkM4vVTpPR
	h2hkEb9Vsyw/AEeGyJPkwtxQX4n8JTrJUmXbDWi9TjJ8dYBoQHSFczbKtI+jZYDxavhpgMjqpLT
	+vx13mhn/gwao635k4U4xhEuXYQ7Lw==
X-Google-Smtp-Source: AGHT+IGKzjAO62p4FpClkQVUrTJgfe9FWmS9MtXp+ACmaG/NRCZxmD36YniOU7rsJoBBK8HqMG4KYCjTGn02zOC8Mpo=
X-Received: by 2002:a05:6402:268f:b0:641:1f22:fc68 with SMTP id
 4fb4d7f45d1cf-64350e8d3b5mr2096910a12.24.1763115974563; Fri, 14 Nov 2025
 02:26:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v3-0-b35ec983efc1@kernel.org>
 <20251113-work-ovl-cred-guard-v3-33-b35ec983efc1@kernel.org> <CAOQ4uxjeZC0V_jWA=8u+vTw0FDWehdu8Owz8qzO8bTqYVb6A_w@mail.gmail.com>
In-Reply-To: <CAOQ4uxjeZC0V_jWA=8u+vTw0FDWehdu8Owz8qzO8bTqYVb6A_w@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 14 Nov 2025 11:26:02 +0100
X-Gm-Features: AWmQ_bl4vISBLfcA735JdkvKtTxS1m2H3GC_9ANj87Q-c70ejASkdAO3pAawhQ0
Message-ID: <CAOQ4uxi05JPptYgXXzLN_C4LAOWyriZGvJdrWydzjBv-q_aGFg@mail.gmail.com>
Subject: Re: [PATCH v3 33/42] ovl: introduce struct ovl_renamedata
To: Christian Brauner <brauner@kernel.org>, NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 10:04=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Thu, Nov 13, 2025 at 10:33=E2=80=AFPM Christian Brauner <brauner@kerne=
l.org> wrote:
> >
> > Add a struct ovl_renamedata to group rename-related state that was
> > previously stored in local variables. Embedd struct renamedata directly
> > aligning with the vfs.
> >
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > ---
> >  fs/overlayfs/dir.c | 123 +++++++++++++++++++++++++++++----------------=
--------
> >  1 file changed, 68 insertions(+), 55 deletions(-)
> >
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index 86b72bf87833..052929b9b99d 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -1090,6 +1090,15 @@ static int ovl_set_redirect(struct dentry *dentr=
y, bool samedir)
> >         return err;
> >  }
> >
> > +struct ovl_renamedata {
> > +       struct renamedata;
> > +       struct dentry *opaquedir;
> > +       struct dentry *olddentry;
> > +       struct dentry *newdentry;
> > +       bool cleanup_whiteout;
> > +       bool overwrite;
> > +};
> > +
>
> It's very clever to use fms extensions here
> However, considering the fact that Neil's patch
> https://lore.kernel.org/linux-fsdevel/20251113002050.676694-11-neilb@ownm=
ail.net/
> creates and uses ovl_do_rename_rd(), it might be better to use separate
> struct renamedata *rd, ovl_rename_ctx *ctx
> unless fms extensions have a way to refer to the embedded struct?
>

Doh, I really got confused.
The dentries in ovl_renamedata are ovl dentries and the entries in
renamedata passed to ovl_do_rename_rd() are real dentries.
So forget what I said.

Thanks,
Amir.
