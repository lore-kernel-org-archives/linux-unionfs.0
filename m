Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A33429827E
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 23:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778972640; cv=pass; b=dofF/BI8xhJQkl0tj7upTR0yjgbd7s5u5rrUn/nxeKDRmIrsLhRNzdye0AjiV8hQQa42/L/FY+QNxiOcag5RXb/5Dxqwxvb8QzwIuqfAttZabUTDHJ5uDq+6Rmy928Ldm90A8Em0FXVHJXozOSyR+U6d91if9g+mzXjxhanwTDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778972640; c=relaxed/simple;
	bh=/y3rTsfAPA+TdIxNGL50QvOlD4VMMFGYfew+jato8a8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S3fqdcuhSVIFERoxluBxM+UEYVG5izitS6Ih6ysWfQ02nTsISbGB6k+Byn277QPLEISmjIPrdRsKofMlYAANZninvxJjQww9vz+HilyiSRLHJcRPMctjibMcybGyvE4I6MJFUxYmMEYuwerjAWk//NHk1WitdBYzfccqccA5XFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TMEfsavQ; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TMEfsavQ"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-67e2498f3a7so2758347a12.2
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 16:03:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778972637; cv=none;
        d=google.com; s=arc-20240605;
        b=S9eGHZJZdexa5MHfa0PuCuCbS55jTPyOQjpYTP+bm8ci5HWNnuKF1U5EG9qH2rw7o0
         C9l2fAGRqToyfR3ryjfh2Tpv3S2YuSjz5qY27cAsuzcxUtw6O95dCkXx4zbXsb2Yl858
         KgDQcTfijXu8HUBgxjYBriSI6jBZ0CvSKQItSBm/c4NFpIR/B1wVoixdQoaIH37Uxu5w
         /YtwuTSJILJI3SUgEiyG2C3dTHURGQdL8A383FETjHR3Sp8F2p2P2lV5P75A2Uts1a+9
         1DB3Xr8K+GZrHx9qScgFPZfHghwLSso9r1JbdJQFpn5K3X9QuXXjZwdif24ivTbuaI2E
         jCJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8DEfMqQ5RG6l620YFRFpDY/yq4az/n7LwelUR3R4K3o=;
        fh=cxqQGx1R0SkxmbgIIeQGWxfeaAe7oE4OmgSiQv/eKfA=;
        b=idxgns8qJEFIokcVHtb5P0AbMKhToXRn57eIkOQUXp/PmnLizmsVHm9i4G4newJ+my
         PN42xTLh34Y6aYo+/Ls1VyNYXVvWCniy4bw/MWDgcOfc9Nu4YfGqn6s6FUc9Hp4zW3Qt
         qVn/jSXPgnPmICfkzSFJYOzDSlOF4xUiAgMcvrQaKeO6umLY7DPR+Y2Z8gOLg4Iju2/1
         6vdk4xs5ecivn+uNZxGrDiJdR8KyGcUbbX0UhKEXvpdxqKlIUgECU15ATMLJgNoFxI0z
         zDYGxygaFMng+uMe9fNYbiptULgqhBC7bR1UbQMjSlcod7MODlV+bMz8k4Z8/L1Ib4u4
         pANQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778972637; x=1779577437; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8DEfMqQ5RG6l620YFRFpDY/yq4az/n7LwelUR3R4K3o=;
        b=TMEfsavQnmdm9jw58MkqHuHSoDZAgycfd8Hj3KUfgFD9T5xX6NujMG6FmoSgNxI+/Y
         G3sfYmFZMehAdJPSH66Slkh04hzo+jZl1UkpPTp5bm0E6KsTcQCbMY7+6oE+aJGQe87N
         Ru8B+QKrb+Ku7JHr8YNlCBEi0milduuhEy3AgFM0Hlfe1o5V253KvgMcT0ZvyBa5EOct
         V0jo0Ve0zIwOgc7nGzi9BD3ZoszlQHjNQSbhyctEejXAMTa6HKHHl+SSf8c8nyr+IotQ
         ejS+o0kuJMzPFx2LIR5p5+xIgOe1u4I3/y508ROQCjbXBR4pmuQ0V9xetnoE0T6RnGBw
         1L+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778972637; x=1779577437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8DEfMqQ5RG6l620YFRFpDY/yq4az/n7LwelUR3R4K3o=;
        b=R0ia95FUnAfBrWUpIWtCSIPcQqmyOP0iZ/QUexfRHPW5auUcOSSYMp/RQCfVhZz/Cv
         B5UmRmRUddEn8UU64xkbSXMJPZBP/kVjkk2HL1/ijI0OSZkKzVG7qbbBQ0tfNguWaxHu
         M7UkIgdd3ouAf/fLLbiYsFlbAccYaXFnZWpNxoDEabgsmflLJCYm9VoUtk9eyidqUWwi
         kgbuZbXJCVY8QODyvI1uboADv8z9OdgDDO7WyyrE1pqx01+X3gZWC8prpi+uHcDjj+Hv
         KTmNh+a2j9U30a2d2Fj6lLHHdZFmJSMv1tR8H/PBB4rz9dz/K6sW9yB+AJtxrp58TW78
         P71Q==
X-Forwarded-Encrypted: i=1; AFNElJ9JpXcRTNRAnTZxojqDONHhcVR/1Zg3Kp+yL+4JXxQ/AJlZdCT5F3AxpH7P4DERh5/TlHqnacJsdR3TQw9i@vger.kernel.org
X-Gm-Message-State: AOJu0YyKPYVQ6vSxhdG+GFlUI7RJbzpOWzIYP5q0cnalyum5bajAo3if
	XwJkPf8Ky1Flrab86CT3UkZ0VPj3FByY3ursdnEsSeqNo9zpMdKrxyOm8H7IOG0U9sdPsCwSBqS
	M21lPn6G8LHor9SL7nS2gE5MsBotm8UUgWBH/4Vg=
X-Gm-Gg: Acq92OFShmwrALBZnV1ycoWgqD4jPEeoAPC8dIztwOhMtoyIqGVXd2Wf7UGpk8Y1/xR
	O9boR+gCCxHw8vNHdzLj2rVVRYYa51luZ0de7/Y2LA+jYGNJh8VR3kRpTwSFlHhpZvMBPQ4KDeI
	/lDXOVLxBCQg7bRxYFuyIAxjJgbb5/6ztCA4/fHK2aYXYdKRMkCsha7PjdD6hv8rqicMBiELwy2
	V8vzq+FuJuOv+835L/RvKXg55w4ZunhLSW2hrekk84e4aIxIrqO64zT68g1GRJbkGsFSQNqiEBr
	xeJkwSekoJEoF7iWcON+lxyB6IwRo4NItPKVW9ut/Q==
X-Received: by 2002:a05:6402:11d1:b0:67e:53a4:5807 with SMTP id
 4fb4d7f45d1cf-683bd08ff27mr4435341a12.18.1778972637445; Sat, 16 May 2026
 16:03:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-20-joannelkoong@gmail.com> <CAJnrk1bm=QOmY9MNZf5rbi-aTLaYetJ2Ziu7A5q9m4MMy5-Y7A@mail.gmail.com>
In-Reply-To: <CAJnrk1bm=QOmY9MNZf5rbi-aTLaYetJ2Ziu7A5q9m4MMy5-Y7A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 17 May 2026 01:03:46 +0200
X-Gm-Features: AVHnY4IY2vvNxdmoXtMcnAf1FkqaoedjoYIyMCVPCDMOwBHuc7ExpaUUbmAQTEM
Message-ID: <CAOQ4uxgfEwhy+YRbZ2H6=Rj4b7d=R-DhZVd+_28MA-9VAd-C5g@mail.gmail.com>
Subject: Re: [PATCH v2 19/21] fuse: add passthrough setattr
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 3:04=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Fri, May 15, 2026 at 5:53=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Add passthrough setattr which sets attributes directly on the backing
> > inode through backing_inode_setattr() instead of sending FUSE_SETATTR t=
o
> > the server.
> >
> > Passthrough setattr is checked before the
> > handle_killpriv/handle_killpriv_v2 suid/sgid stripping because the
> > stripping is handled natively by notify_change() on the backing inode.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/dir.c             |  3 +++
> >  fs/fuse/fuse_i.h          |  3 ++-
> >  fs/fuse/passthrough.c     | 28 ++++++++++++++++++++++++++++
> >  include/uapi/linux/fuse.h |  1 +
> >  4 files changed, 34 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index 4c7e3e1604af..b67b3b334e69 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -2506,6 +2506,9 @@ static int fuse_setattr(struct mnt_idmap *idmap, =
struct dentry *entry,
> >         if (!fuse_allow_current_process(get_fuse_conn(inode)))
> >                 return -EACCES;
> >
> > +       if (fuse_passthrough_op(inode, FUSE_SETATTR))
> > +               return fuse_passthrough_setattr(entry, attr);
>
> In the v1 discussion [1], there was a suggestion about gating
> FUSE_PASSTHROUGH_INO on FUSE_HANDLE_KILLPRIV_V2 to avoid the
> non-atomic killpriv path, but I think we were only encountering the
> non-atomic killpriv path because I was calling
> fuse_passthrough_setattr() in the wrong place. I think we can avoid
> this altogether by just having the backing filesystem handle all of
> the suid/sgid stripping atomically through its own notify_change()
> path, which will let us skip all the fuse killpriv handling logic in
> this function.

I think it still matters, but to the only-passthrough-GETATTR case
and I am still in favor of making this change.
My point was why have the discussion whether getattr
for the purpose of killpriv should be passthrough or not (next patch)?
Why not drop the next patch instead because it will become moot.

If FUSE_PASSTHROUGH_INO requires FUSE_HANDLE_KILLPRIV_V2
it means that FUSE kernel is never trying to play games removing privs
itself, not with passthrough and not without passthrough.

Quoting your comment on next patch
"I think there might be some use cases
though where having only getattr passed through and not setattr is
useful (eg server wants fast stat() but needs to intercept attribute
changes for access control or policy enforcement)."

Valid use case, but in this valid use case, said server may reject/allow
attribute changes, but eventually if it allows them it will likely apply
them to the very file which was set as backing inode, so essentially
FUSE_HANDLE_KILLPRIV_V2 is the natural choice for a
FUSE_PASSTHROUGH_INO server, even when it wants to introspect
setattr.

I think the same is true for ATOMIC_O_TRUNC.
Either backing fs deals with O_TRUNC or server deals with O_TRUNC.

But this is my opinion - I am open to hearing other opinions.

Thanks,
Amir.
