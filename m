Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F49382F03
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779127491; cv=pass; b=pFw52n5S9dvwKMikP4lMB26o6nLYqjjkkd3/a3qbf+VMgMhaSPetUlLtBHOjPyNPnO3y+YmvDus94DYJA3bcFqy6oNIzHZXw0nugdsdOfwPke9iR9xvCjGI5fm4CovUD9fNpmQrg1jKVZ7utsjhzpf20pxbnVKbIVRcnwI+/Apg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779127491; c=relaxed/simple;
	bh=kDDg6N0nN6KEff1emIwXgNf3VdPR+RZcL3mDcfSvr60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YYP1HW11xWnjT/RiCozVYCME60A5ca+Jq8BBbtnZGR6B73xN40bwTHjPUWq29/DL4wV2Fyk/BcDhVNNiymTW4vpzEyGFb8YGtIDPzenzIem5Z2MQMf65EZVRu6NrAWsMKabQ5JIzOUKP1CyVYEwZw1KmOLoPtA4lhcD5lx9Jm74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TjDdm/TH; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TjDdm/TH"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-441209fb77eso1546727f8f.1
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 11:04:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779127488; cv=none;
        d=google.com; s=arc-20240605;
        b=BDMxAPtV47E2fZxNbg5jKcqO8WS+ySkQ7W8yuxAXFAHsuZoAKYE46BoOKPPt5MDgVU
         KtOqtEhJ2m/D270vPNXBXfRvQrq26/V5NbdU7VGwJgPFBHaVfmoHlWPLSYfBgW3uh6U+
         Cloira32zpvrBvJYwtrMeWrZ9LBBAxFRrpQUA7Le3pSFhES58C8TS0uBL8Opa+dayrTL
         yDVY019NJn06ddln5e+hngYdWtsQuSqpNDs3W9/GzxdjnHwEaGwnsLFZWINZw2Y3M1sY
         yRTr5XzMiKIqUihflxNMobK8HgRJugU8ha8/AWQeVgU0c/os0Xe7bsNfRwfYbR3flPaM
         Bafg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CljLoIYskFigaXEtOn3tL+BNQgFNUCP9mu4XODfMHjI=;
        fh=fDZOicXj3tV61CbyyaTTUn7pYGeQhNvVfB1H88TYm9A=;
        b=Ng/TuYeyFtxM0sIy4qAgDP1qDMZjDccSc6wI0wHzXe0xDdJ1UMpI+Y5orUT3Jm5p8h
         Znbeb8eZLCWQym18qvgglQOA9UVnrdgF+XKvXTEwFmUrmullT5jxpoHvNseICNPF7cTj
         FoZweapr+EURCoAEsk/9a4TewlDqRXY3E84yXjE/qA/JOicnL1sWk04zpSul2yQxXwWW
         IiKT2408X9/SUQ5zZL0AB+/22ZtuiZFduSj4wZdsDFlMX6wmon7ZIcfvIRP7+6XidLfQ
         IrPTE/xShmvOvP5uqogQwSAjIEdR2iOrhQwxMov3+GHEsNISmdOdPMacc7p6P2/aHu/b
         CLhw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779127488; x=1779732288; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CljLoIYskFigaXEtOn3tL+BNQgFNUCP9mu4XODfMHjI=;
        b=TjDdm/THMqWBYorB2O5r8AoKuNBn2E3Ru04Mbr3xb41idenx/x6TEYiFI8dclIMs/w
         12wUoMpLXscgNCbHJJokVfKiNQl+3rHOE96Ni/SDgUyBULSLxL3L9vzQ9jl/pTP32WHD
         p9r3vVPTc/JrSQ8eyxJeZANArGHw7Pw97lb7jEaoMZEFLHsUt2T4L3kSNWfR3bB5DtQ2
         eeI8dkzcN17A9+QK+1Sh0g13wRZmeLFdWifxsFa7/xD8I1BTHg49YXh7Gf8PWkGjQX2H
         GnPPIbzyvr3h9pUtJiSBBQjFadGL6BP0FpOUXPa/vhApYe+bNYR05+5NGMcCkCGT4evs
         BSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779127488; x=1779732288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CljLoIYskFigaXEtOn3tL+BNQgFNUCP9mu4XODfMHjI=;
        b=E1HiJgojPtGmzQpBctgie2CyQsth6P05jaDyfM5znYHb56ecD05c4IA2rTYmTFnm0D
         G4y7D5nQ4vHfPZOUO/raEuUPhJNEdNyCHfwCsSbZM1Prsq3P37Hh57Vm/+2dw+ZTPKk9
         OwqeJSrk2zLMvfeWvoBVXTJMjM2pTH/orIxxcl2iXbWcv3Kb317aCdiLybwpKa0TXFEl
         vjdbx7lPWVSLuj8VTRdD3wJK639F6VQpMTpAjOhPpHQ3tQYX5M0V6+jzZNYZd5D/MNb6
         mmKWXoT3QarJzLDqxctyrlkmaKtRs52hMJwZ6Qal6V0GwfU9c6EVYQbMTyryURFjGCj6
         Rlkw==
X-Forwarded-Encrypted: i=1; AFNElJ9qMAGahTQxHCh90nN/RxNHhZ3zeTweE/rD4npDosDqAYlHEpD9ojwY1it9mOliWqi1oSavRxr14/G6IedK@vger.kernel.org
X-Gm-Message-State: AOJu0YyU72ldfO70ZO5KTs38Z4ZPl8c6K74US57+fw+rbe+PqGyWYDkY
	kv9nHZU75vVMH/jxBARsFsi5SlDwc5+IxkC0jXdCUh5sSnWbyJqcGyKVhmzcd+5VFN5Iw927eD+
	stKsl7OYStvu0dem8wSJ6Qqg5u3NfN9M=
X-Gm-Gg: Acq92OEit3xotkms8YtSktxwJBFyDnf5DUFjXKdd66BwzOmphAerXEe+2aJLks4IMp4
	0azUkOGRjhz1qLNUOJTDTHdhUs8rON91l8QJc+Him5crk842wAjtIwjC7f00YJvc1lkxdsYHYTi
	HU8vdjILwWXSQycpcNsM0tbqqbmNnlHr1RAQdL8sPBO9hO/MDdaWcNkfAcN9+zVaSNWYz0jpuoQ
	9DN8gdC/wG9AWgFYRV7Ua+qKP0L+HFnQ9MYgGUOaXVHc/z196wOmb+B0tmKdn+EWFzw9KsgNzJu
	lInBm0rG9PTS14Ii
X-Received: by 2002:a05:6000:42c2:b0:456:d742:8b4f with SMTP id
 ffacd0b85a97d-45d91438680mr21134881f8f.12.1779127488214; Mon, 18 May 2026
 11:04:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-3-joannelkoong@gmail.com> <CAJnrk1YUjqd+j1yLXuO0M07ueCUYNC0NqgwmQSm3OiY3hnhgZQ@mail.gmail.com>
 <CAOQ4uxhyZU_6jbv8kY8od_SgG9yQ6aX+KcB2c1um4DajJdSPqA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhyZU_6jbv8kY8od_SgG9yQ6aX+KcB2c1um4DajJdSPqA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 May 2026 11:04:36 -0700
X-Gm-Features: AVHnY4LHIzzo9vmjpUtLlchtf0O-41uZhMAUHOsNmTtLXcemqB7KqU8vLK1LXnU
Message-ID: <CAJnrk1aEc1nf7ax0UvdCi7rkzbWDFpgjJcE35HCQyWcPLdoOnw@mail.gmail.com>
Subject: Re: [PATCH v2 02/21] fuse: prepare for passthrough of inode operations
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 9:11=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Sat, May 16, 2026 at 3:34=E2=80=AFAM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Fri, May 15, 2026 at 5:52=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > +/* op bits for fuse_backing_map ops_mask */
> > > +#define FUSE_PASSTHROUGH_OP_READ       FUSE_PASSTHROUGH_OP(FUSE_READ=
)
> > > +#define FUSE_PASSTHROUGH_OP_WRITE      FUSE_PASSTHROUGH_OP(FUSE_WRIT=
E)
> >
> > Do you think we should couple the passthrough op code to the fuse
> > opcode so closely, instead of defining the passthrough ops separately,
> > eg doing something like this?:
> >
> > #define FUSE_PASSTHROUGH_READ         (1 << 0)
> > #define FUSE_PASSTHROUGH_WRITE       (1 << 1)
>
> Don't drop the _OP_ please
> Need it to distinguish from FUSE_PASSTHROUGH{,_INO}
> and we need to think if we want to format this as 32bit and extend later
> or start with a u64 ops_mask format from the start.
>
> >
> > In the (far) future when some more advanced passthrough features get
> > added (eg full subtree passthrough), it seems like we'd want to add a
> > passthrough op for that,
>
> I don't know. fuse_backing_map has flags, why would we want to put that
> in ops_mask.

That's a good point, I like your idea of using flags for that.

>
> > but that wouldn't map to a fuse op. I think
> > there are also some fuse ops we might skip defining as passthrough ops
> > but are implicitly passed through (eg FUSE_STATX which is covered by
> > FUSE_GETATTR),
>
> This could also become the case with FUSE_CREATE{,_HANDLE}
> or {FUSE,FUSEX}_CREAT.
>
> TBH, the fact that some ops will never be in the mask and
> that some ops have a canonical bit in itself does not justify creating
> a different mapping. Do we also want to squeeze the mask into 32bit
> and leave reserved space? my intuition is to leave it u64.
>
> > so it seems more intuitive to define the passthrough
> > ops as describing capabilities rather than implying that it describes
> > what specific opcodes get passed through?
>
> hmm. I guess you have a point that it is a bit limiting to commit
> to this arithmetic in UAPI.
>
> My thinking behind this was ease of use with these helpers:
>
>        if (!fuse_passthrough_op(file_inode(in), FUSE_READ))
>
> but those could just as well be macros:
>
> static inline bool fuse_inode_passthrough_op(struct inode *inode,
>                                             u64 opbit)...
>
> #define FUSE_PASSTHROUGH_OP(inode, opname)    \
>              fuse_passthrough_op(inode, FUSE_PASSTHROUGH_OP_ ## opname)
>
> #define FUSE_BACKING_MAP_OP(map, opname) \
>        ((map)->ops_mask & FUSE_PASSTHROUGH_OP ## opname))
>
> ...
>        if (!FUSE_PASSTHROUGH_OP(file_inode(in), READ))
>
> wdyt?

Nice, the macro idea is neat!

I feel like it gives more flexibility to define it separately and I
think with that, u32 would be more than enough bits as well. But I'm
happy to go with what you think would be better here.

Thanks,
Joanne

>
> Thanks,
> Amir.
