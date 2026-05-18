Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826ED24DFF9
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 20:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779137820; cv=pass; b=iTibi0IB7PmX+o6KQ1Q8UgVQYS9JzdqK0pBmFrhxf2S18rJO3v9sO6qT1WGJzb9akO0BdAOUECrkEFNxN0Ct44/D5ypXPaGXXEz6UADOShhbRQMvRAwiv0U2u6v0sfOEuOO1ywsvlxnE89k9/2gkVt5MEw2qrrzkm5anPBRs9qU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779137820; c=relaxed/simple;
	bh=O7yNteNB8Vvmz+auSl9LhOd2cAR6aF1IyCYgjo1KoT4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eCaFDFtT6CuEMhBLvOUMxDieZMZeFtH0JSUP71CdgBo95svbzxKYKqsXgPX7i5eGxgdDeV0kApwtWpfiljWta9/V64X5dQB6gv1fhz3hRPnvbiQphh21r9M3SS+Wsn8mNyZDFOCnXUl5xareg/9Y7FRBNxmN0oTL8omzQC8Wt70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GZuanihf; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GZuanihf"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488d2079582so26653325e9.2
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 13:56:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779137818; cv=none;
        d=google.com; s=arc-20240605;
        b=fEcdOc0qBfTkSQdXkn7lAGMjqNiICoQMoOTXJ1VGiwWe+Fvig2iblBFmuOqxs0h5lH
         VYjX8dP+dvPjRj+PJKiO8Iy6RvQh9BN/3sebNREgeC/jrxaKYMOcj7BLRwYS8KEy82vd
         atZXvmpSGV6zUd/jFz4yBHznKk9zvg41/pdhk4MQHAX5Kpj6sz5BM7k7pldEZl2bgobD
         RXUFkpYB4Aboyz7MB5e4Vyh9Jesqm1WMQylGhxRqgEniMsapKVvodmB8dSGUkJ5ajB3+
         qxH0U1k+vZGv4STa0Z+0ITutqahJ4myHHD8hTHLuq7qoO7UmlVu7CKaDa4dlVr6Ra1Yc
         8dKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vlQVAcswqTiXHTsw5kgApTgT9RUz0A4MUuUWzK6vBMY=;
        fh=BxYLak0ZEd0KQjObmcnnDVceYCkNdHB53324DoNJGpA=;
        b=Hwg8h2mywln7HRpxAoSbGr8RQvGuQeGFnTDK8hHJR1y5jkFaFG59VWIedaywyi3zpm
         I29lPGg8uvvvTknpoeTfYcukWRpfbw6+HeahxMPtPY+/GLEza9jZ6PthVMR2vDn6yWeD
         ZXe9OpUTUCruI1szbdg83sXYaSGw81fs6nifkvhvFoUQS+cpxQIXQfN1V2Yzqa3SqjlE
         Ed2oCfG/dyaZ6NKx2K4DPeJWd9RBU2nGIJlrfWtQKGjRHqMgdQTjg2/WJsqs/6EhFCYn
         XKPyI/zYQ8pRlrxEx40QN2x7eq341Gh/+F8U3BZ/hTBN6D8Z3a1pfyjtHaJ3aqsRCZEf
         CxJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779137818; x=1779742618; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vlQVAcswqTiXHTsw5kgApTgT9RUz0A4MUuUWzK6vBMY=;
        b=GZuanihfW/KRZjsMtK08oeTFB72ExafApi84ccVGixKE81rXWTCVHXfx2lEwX9y8UW
         PIlc/Ya0N9B0zHwu2exRO7XHXzn5E1YR6xWU84d02huBkxVgyV8z+otuMR1PKMEOAesD
         jcysJOef7XrC/q8U244SxWiaIG7hmpIIfMrZ8RE/pfWvd6gypq0KDmaQjPh5Two65uxN
         NHtWt2pNt7znjmsYGnf8eW5qxbq4n7H886xdSnXY4f/Wa8yjgOw1dCphtFwFsc73aaFp
         Zf4XxfLQeVB62UzGhEEiTscbEbJuQoumVwuNpuYw5EezezmDPpAvIJP9iT+CbjwXUrO5
         9ibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779137818; x=1779742618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vlQVAcswqTiXHTsw5kgApTgT9RUz0A4MUuUWzK6vBMY=;
        b=pyj5/6TIg8Kh2CFu2ScmWnSxt31FWjY/39FVxXuZOyh1EldisQG6POEiNsmp0Xkf8u
         pwOTtFEQ2T/DkyDxNPvdsm+f7s0fJIREZAV7G9FRDktGcuCeicQSC7145OuzTYeBMeiq
         xvhYx+UxninPhwXxRKGSJUn5P73HsVoRdCnlOjUTZMmvyyr5cWHzxdaMPf9ARUSua6aQ
         vh/tIJyw7UWoiMSiCqbm45rZby6qxTORGRZU8krqYnMgOYa0QbST8WPe9n3azyYj2Ioo
         hUckW48aYSctiC7yRIwjvpV13SnNx5p1xxD+FDFxhmCzF4M30vZd83/lsjux0FViGMfn
         FCpA==
X-Forwarded-Encrypted: i=1; AFNElJ/VONSiY4Il+EtJoAjYSObdOFyFVgdbVGc2/hEZmvdbgicPWZuESeTfvhUfFRvr8ThXyAI0lzvJxSBQMiEK@vger.kernel.org
X-Gm-Message-State: AOJu0Ywyqo86NBe4VPSfeMtrGLEDjCcOwXa4OYaI3IvkEIB5Lv6+kQmY
	4UDJg6k77y8UwVjNM8xmkPGMq3B75Ht3LSiPRSRqZFDzcXRye1ipjQ+lPBd2O57ncexxHCLsdn1
	tPat4GXsvca0xeSidyb2OqGCgFdJr06D6vioy
X-Gm-Gg: Acq92OFl8+zKewgD/EjLy8eIW9yYbqhvrvyuoNjgANUfi1HeLB7hApiu0uC782CGbl5
	IatxPJXfKnpRTayVF/ZuAvlFUfD55vnXPa5XPvJKKlVbji7jI7x+qbIFI/8ZHUqgWXqDxDyRjTo
	3K1r8AOWbF4uCnDAmL9dRh/7fe8MCE07SNedTap0mRegMUPBVodUgPylaaJf4prvyCyv13fKZK1
	sOuGsqDx67X3rEJQczivL7L4NvdO8oQJTPq6QTDiLjbr46MpYxu8uNN/w0QCFkwo8zXJ8c4TSfv
	OodT1w==
X-Received: by 2002:a05:600c:858d:b0:48e:5990:96b1 with SMTP id
 5b1f17b1804b1-48fe6514c62mr204044195e9.23.1779137817779; Mon, 18 May 2026
 13:56:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-3-joannelkoong@gmail.com> <CAJnrk1YUjqd+j1yLXuO0M07ueCUYNC0NqgwmQSm3OiY3hnhgZQ@mail.gmail.com>
 <CAOQ4uxhyZU_6jbv8kY8od_SgG9yQ6aX+KcB2c1um4DajJdSPqA@mail.gmail.com>
 <CAJnrk1aEc1nf7ax0UvdCi7rkzbWDFpgjJcE35HCQyWcPLdoOnw@mail.gmail.com> <CAOQ4uxhUZByYu6hp0TSekZ49FZDp20xPTpG9CmFDjtiTfh8Sgg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhUZByYu6hp0TSekZ49FZDp20xPTpG9CmFDjtiTfh8Sgg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 May 2026 13:56:43 -0700
X-Gm-Features: AVHnY4Kk7UjvKo5G96rFFAWOoPehDm6nCtStEnSj10UV4YnAhPnsD8T12ZhmYgI
Message-ID: <CAJnrk1ZO5s=71tMEJZ5Lt3cfjPijPt2bzucbYT70qJE-GuWz7w@mail.gmail.com>
Subject: Re: [PATCH v2 02/21] fuse: prepare for passthrough of inode operations
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 11:39=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Mon, May 18, 2026 at 8:04=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Sat, May 16, 2026 at 9:11=E2=80=AFAM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > On Sat, May 16, 2026 at 3:34=E2=80=AFAM Joanne Koong <joannelkoong@gm=
ail.com> wrote:
> > > >
> > > > On Fri, May 15, 2026 at 5:52=E2=80=AFPM Joanne Koong <joannelkoong@=
gmail.com> wrote:
> > > > >
> > > > > +/* op bits for fuse_backing_map ops_mask */
> > > > > +#define FUSE_PASSTHROUGH_OP_READ       FUSE_PASSTHROUGH_OP(FUSE_=
READ)
> > > > > +#define FUSE_PASSTHROUGH_OP_WRITE      FUSE_PASSTHROUGH_OP(FUSE_=
WRITE)
> > > >
> > > > Do you think we should couple the passthrough op code to the fuse
> > > > opcode so closely, instead of defining the passthrough ops separate=
ly,
> > > > eg doing something like this?:
> > > >
> > > > #define FUSE_PASSTHROUGH_READ         (1 << 0)
> > > > #define FUSE_PASSTHROUGH_WRITE       (1 << 1)
> > >
> > > Don't drop the _OP_ please
> > > Need it to distinguish from FUSE_PASSTHROUGH{,_INO}
> > > and we need to think if we want to format this as 32bit and extend la=
ter
> > > or start with a u64 ops_mask format from the start.
> > >
> > > >
> > > > In the (far) future when some more advanced passthrough features ge=
t
> > > > added (eg full subtree passthrough), it seems like we'd want to add=
 a
> > > > passthrough op for that,
> > >
> > > I don't know. fuse_backing_map has flags, why would we want to put th=
at
> > > in ops_mask.
> >
> > That's a good point, I like your idea of using flags for that.
> >
> > >
> > > > but that wouldn't map to a fuse op. I think
> > > > there are also some fuse ops we might skip defining as passthrough =
ops
> > > > but are implicitly passed through (eg FUSE_STATX which is covered b=
y
> > > > FUSE_GETATTR),
> > >
> > > This could also become the case with FUSE_CREATE{,_HANDLE}
> > > or {FUSE,FUSEX}_CREAT.
> > >
> > > TBH, the fact that some ops will never be in the mask and
> > > that some ops have a canonical bit in itself does not justify creatin=
g
> > > a different mapping. Do we also want to squeeze the mask into 32bit
> > > and leave reserved space? my intuition is to leave it u64.
> > >
> > > > so it seems more intuitive to define the passthrough
> > > > ops as describing capabilities rather than implying that it describ=
es
> > > > what specific opcodes get passed through?
> > >
> > > hmm. I guess you have a point that it is a bit limiting to commit
> > > to this arithmetic in UAPI.
> > >
> > > My thinking behind this was ease of use with these helpers:
> > >
> > >        if (!fuse_passthrough_op(file_inode(in), FUSE_READ))
> > >
> > > but those could just as well be macros:
> > >
> > > static inline bool fuse_inode_passthrough_op(struct inode *inode,
> > >                                             u64 opbit)...
> > >
> > > #define FUSE_PASSTHROUGH_OP(inode, opname)    \
> > >              fuse_passthrough_op(inode, FUSE_PASSTHROUGH_OP_ ## opnam=
e)
> > >
> > > #define FUSE_BACKING_MAP_OP(map, opname) \
> > >        ((map)->ops_mask & FUSE_PASSTHROUGH_OP ## opname))
> > >
> > > ...
> > >        if (!FUSE_PASSTHROUGH_OP(file_inode(in), READ))
> > >
> > > wdyt?
> >
> > Nice, the macro idea is neat!
> >
> > I feel like it gives more flexibility to define it separately and I
> > think with that, u32 would be more than enough bits as well. But I'm
> > happy to go with what you think would be better here.
>
> I am not sure. Let's keep it u64 for now.
> Since the struct is in an ioctl, it does not really matter much.
> If we ever consider moving backing_map responses inline
> in lookup/readdirplus response (maybe over io uring) we could reconsider.

Sounds good. For v3 I'll keep it a u64 but define them separately and
use your macro helper for mapping from opcode to passthrough op.

>
> In case you missed the exciting conversations about this API
> original fuse passthough patches from Android had the backing fd
> in the open response but it was deemed unsafe writing fds to
> /dev/fuse, so ioctl was chosen instead [1].

Wow, that's a clever attack. Thanks for sharing the link.

Thanks,
Joanne
>
> With io_uring I don't think the security concern holds, so I see no reaso=
n
> why backing_map would not be possible in-place for readdirplus
> responses if we wanted to do that, but we can also ignore all this for no=
w.
>
> Thanks,
> Amir.
>
> [1] https://lore.kernel.org/linux-fsdevel/CAG48ez3ZX8R9kRAQhung2_e3wjowu5=
cPh7WL3U866mkga-kftQ@mail.gmail.com/
