Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C109B3E5A25
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778947913; cv=pass; b=R69g+JyiKpV1LX91pSgmvPxbyxA6nh98tPVLTz+vWPS9qkVdyOfCBZlYwsPRjQki3F4FNV5F4FrDbZQ5bkRas8OuyIIdsplXs5aSjckxpFvOzeiplrh75s6B1IyL1KcLjnmsNyUJjYA4SaK7YxweCR2S9edHMCn+nubJAz518RQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778947913; c=relaxed/simple;
	bh=Q7nlBd/BqBQHvksCEGaenGOCteLulS+SgKiHUiSNSEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CsgUEJkpGUuZRd4gDwRlNjtB8nb4do4ymOOcXU0DFu5PPkZk/GVMwusIh1a9WdLV0aY8M/DsaE9HjtWVtVD9q96fBMWpwsEFIrs6TBVqLqWlxTcQGVSEMzvVLnXz7w67bAM5oKoB6ppJveZpMplYOPCdFEhaphxlTeMEyk4OjQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UHKjgESu; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHKjgESu"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bcd3c190f71so165039366b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 09:11:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778947910; cv=none;
        d=google.com; s=arc-20240605;
        b=QR89po4lPLyhUt0FHOBuhZGxwJ5ISRejtuYCKn+B/QMxuPBYlKs/73LzbqPlgaCCYR
         5apOmiu/k/yXxMYPLjjaEo1PXNr0wKyw1q1nRxs++TOTe/sg7na18r0zMgciCuh4fR73
         qXG7nNiJB34SUuq8EnAdt0VC7Y7t+iL9XVghrLehBGJCxssvnqHntQEZ+Hers9PCOcYa
         JQ816BBV5tNSw5xA0a0NoDL05b6ct1/aXfjX29nwXsOwYpVMgUKpFSugzwee8G1YWOPj
         bNA75zRdaYAHzJOnhcUHzzm0XUqPlI0knQErSUVMivb8MTBqZcrkB8ZF7EFXJY04FtX0
         JsCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uAZW2MBE8275Ldt0n/IGNTEv2ZI5Fh5vxkOF7P2VqHg=;
        fh=k/38k5Frqa22thpL+eRkH3xpG2GNmSviDg6/W0XBdlo=;
        b=M2Kc0dmI/O897NRCqAK6qciIy4KAgcEToresr0FHTtjn9DGZQZLl6GfYcPQjcHYxFi
         SR+jodyfDcFyq3t0x/mLjQEAMYN++tKHRHv18P3yUeF0Ycyg6Kzev8iQs4WZURJ48LzX
         KUclVZMFcRaVrxPms3kE2DMFFoBxmS65CQGvBsi2eGzf664+8dDEotzNwXMEYAiLN9De
         M5hco067+7DVFCCubgbAtcjLt+lDcC3OoJmBgdwxx0j+4I7Ha6zew44tqD7SCUoKDn+v
         KA9FK4Q4vX3HQB+ZUGPzitvNRiferRgKCsVVJvfi5NU43Dw0SRtMlXNdGhjjN0n/wIbT
         4plQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778947910; x=1779552710; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAZW2MBE8275Ldt0n/IGNTEv2ZI5Fh5vxkOF7P2VqHg=;
        b=UHKjgESueyRnG0Qs3XcEuBaCbh248oZDehbhRdsreFuXeKoqxB9AsFEBaG9JOM2BNM
         D8ivcfbI8YHpW2baywk8CmpdGegHHLcbvadNtDr+u9VD9Cfp6XcQRTB6lzk5W3Ba9fjT
         MRYH0hTQCSYTGxf4zpdPGHvJ2yWveybeuSHE/RxK7rGfAk4O2EoRNnyTjsx42SCZPS43
         nuXdv0NY3TlGO9FOv321mm7zX19+mD828Z9arkXoJUf1jRXlewwpSRReYqFK2YpqDC6p
         oYLpfx+9jDf5Y+FVNkc0k+Dhl3rUPv8OHX7nTQmQ76t+OUXcFYooDl/z8ikOxZgRe0b6
         90HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778947910; x=1779552710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uAZW2MBE8275Ldt0n/IGNTEv2ZI5Fh5vxkOF7P2VqHg=;
        b=Zr8QT/FiVaZlim3Yy/dQg4OqGzyO4D3txixidpekCN3fMXV1/4f4HNzBc9zzQkZq2V
         83p7sR91o5/gRlpV8EI8uq1GkPgLyIkxJR4K42iqUw7ErYZhp6JnSYN7rg/jIpFAVvn0
         aswKsdVzYmuWd09JgKU+M0ixbBweMo7y9T2SJMFiuLbF686q6gutJadG7o4WrEzVFfiz
         F0U8MZsfNzqhnyBI193sTpk5n+wTlshgQxUh1RI2IbMPb2ev02EN03PylCZK578Fvuky
         uSFoPd912QK0QvUhlXGlJ98bWi2dRWcTKR54AQ8huJLLc+zsbJjlF2f4MpiyqQCegYG5
         gTGg==
X-Forwarded-Encrypted: i=1; AFNElJ+0/l+LFi0Y/Tc4jTpiMlDA1tP0rqdSx7zrRMwZ9gw2W5ptSH6OEwXdxo1/RdkAShcD1il3Is0n9qMmPlEl@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr55x0URXxtpWIxGAtaM1se6rrOWLwLeOi+FnqL4vlg2dEzeti
	8/8ciiNdpEqM/34oqHvivVuiDMQ0BdzW6u42Bsqc2WPUJ2Ks9f7nIl+tXN5tgYpbS4EFXqJgdbU
	LKS7h/81ONfxtmIKm2WRhRNkFwvDtleU=
X-Gm-Gg: Acq92OF7D194pW3G2sr7sHoC7iBjjNZa9O7oGFt4eROrfStlacKuIByxhIVzvungsk5
	sTrJVA4BqEXRKOgVBVbXc0qrAPkJzHjZuopUiUS2phxfSuDpySS+sMluY/vPccVgzMGuab7cJhd
	3dxTcn0KCWfzF953tTwNKKWhbgvfEaFN1hEQINnqfczG61U6V1/XL/ENpmTfkLxX41aqHjdi82f
	DjBBlN7YwMJ4bYD163SJ7VgrwXex4XnDgNmNHbsU72HodeDCTEx5fiuXLYDP0sEh/CnmpKUub0Z
	Zw9EJjXH7nMoJ2ksgVMSPq3ytju8oa5AlFVZAqOd3I8Y69OtQSZ7
X-Received: by 2002:a17:907:c714:b0:bcf:9dd2:f79e with SMTP id
 a640c23a62f3a-bd517964d82mr481784066b.29.1778947909758; Sat, 16 May 2026
 09:11:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-3-joannelkoong@gmail.com> <CAJnrk1YUjqd+j1yLXuO0M07ueCUYNC0NqgwmQSm3OiY3hnhgZQ@mail.gmail.com>
In-Reply-To: <CAJnrk1YUjqd+j1yLXuO0M07ueCUYNC0NqgwmQSm3OiY3hnhgZQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 May 2026 18:11:37 +0200
X-Gm-Features: AVHnY4LRXBoTp7VSRpHV_Q0T8iOBc_MEV3aFDSOimmKfnbZNrPwrIz-QjGpKgXA
Message-ID: <CAOQ4uxhyZU_6jbv8kY8od_SgG9yQ6aX+KcB2c1um4DajJdSPqA@mail.gmail.com>
Subject: Re: [PATCH v2 02/21] fuse: prepare for passthrough of inode operations
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 3:34=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Fri, May 15, 2026 at 5:52=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > From: Amir Goldstein <amir73il@gmail.com>
> >
> > So far, fuse passthrough was implemented for read/write/splice/mmap
> > operations for regular files opened with FOPEN_PASSTHROUGH.
> >
> > A backing file is attached to a fuse inode, but only for as long as
> > there are FOPEN_PASSTHROUGH files opened on this inode.
> >
> > We would like to attach a backing file to fuse inode also without an
> > open file to allow passthrough of some inode operations.
> >
> > Add field ops_mask to the input argument of FUSE_DEV_IOC_BACKING_OPEN
> > ioctl to declare the operations that would passthrough to the backing
> > file once it has been attached to the fuse inode on lookup.
> >
> > Setting the FUSE_READ/FUSE_WRITE operations in the ops_mask is not
> > required because those operations are implied by FOPEN_PASSTHROUGH.
> >
> > When setting operations other than FUSE_READ/FUSE_WRITE in ops_mask,
> > non-regular backing files are allowed, so we need to verify when
> > attaching a backing file to a fuse inode, that their file types match.
> >
> > For simplification of inode attribute caching, for now, require a
> > filesystem with FUSE_PASSTHROUGH_INO (one-to-one mapping from fuse inod=
e
> > to backing inode) for setting up passthrough of any inode operations.
> > We may consider relaxing this requirement for some inode operations
> > in the future.
> >
> > Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/fuse/backing.c         | 13 ++++++++++---
> >  fs/fuse/fuse_i.h          | 30 ++++++++++++++++++++++++++++++
> >  fs/fuse/iomode.c          | 16 ++++++++++++++++
> >  include/uapi/linux/fuse.h |  9 ++++++++-
> >  4 files changed, 64 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > index 4be9ccc5b3ff..0f1e1c1ec367 100644
> > --- a/include/uapi/linux/fuse.h
> > +++ b/include/uapi/linux/fuse.h
> > @@ -243,6 +243,7 @@
> >
> > +#define FUSE_PASSTHROUGH_OP(op)        (1ULL << ((op) - 1))
> > +
> > +/* op bits for fuse_backing_map ops_mask */
> > +#define FUSE_PASSTHROUGH_OP_READ       FUSE_PASSTHROUGH_OP(FUSE_READ)
> > +#define FUSE_PASSTHROUGH_OP_WRITE      FUSE_PASSTHROUGH_OP(FUSE_WRITE)
>
> Do you think we should couple the passthrough op code to the fuse
> opcode so closely, instead of defining the passthrough ops separately,
> eg doing something like this?:
>
> #define FUSE_PASSTHROUGH_READ         (1 << 0)
> #define FUSE_PASSTHROUGH_WRITE       (1 << 1)

Don't drop the _OP_ please
Need it to distinguish from FUSE_PASSTHROUGH{,_INO}
and we need to think if we want to format this as 32bit and extend later
or start with a u64 ops_mask format from the start.

>
> In the (far) future when some more advanced passthrough features get
> added (eg full subtree passthrough), it seems like we'd want to add a
> passthrough op for that,

I don't know. fuse_backing_map has flags, why would we want to put that
in ops_mask.

> but that wouldn't map to a fuse op. I think
> there are also some fuse ops we might skip defining as passthrough ops
> but are implicitly passed through (eg FUSE_STATX which is covered by
> FUSE_GETATTR),

This could also become the case with FUSE_CREATE{,_HANDLE}
or {FUSE,FUSEX}_CREAT.

TBH, the fact that some ops will never be in the mask and
that some ops have a canonical bit in itself does not justify creating
a different mapping. Do we also want to squeeze the mask into 32bit
and leave reserved space? my intuition is to leave it u64.

> so it seems more intuitive to define the passthrough
> ops as describing capabilities rather than implying that it describes
> what specific opcodes get passed through?

hmm. I guess you have a point that it is a bit limiting to commit
to this arithmetic in UAPI.

My thinking behind this was ease of use with these helpers:

       if (!fuse_passthrough_op(file_inode(in), FUSE_READ))

but those could just as well be macros:

static inline bool fuse_inode_passthrough_op(struct inode *inode,
                                            u64 opbit)...

#define FUSE_PASSTHROUGH_OP(inode, opname)    \
             fuse_passthrough_op(inode, FUSE_PASSTHROUGH_OP_ ## opname)

#define FUSE_BACKING_MAP_OP(map, opname) \
       ((map)->ops_mask & FUSE_PASSTHROUGH_OP ## opname))

...
       if (!FUSE_PASSTHROUGH_OP(file_inode(in), READ))

wdyt?

Thanks,
Amir.
