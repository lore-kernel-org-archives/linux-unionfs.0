Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895762222C5
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 14:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519315; cv=pass; b=XF6FcCo74FBBmOHi2dmvbS5wCrDO3H8ySZC3lV3gUAlWJmO3oV6/5miX9fRy32TW+mFamULBlg23YPjdsQnX7w9qn6Tp1FWll779zkaS5LXxCV7J6C3h8iqodlAnHMbNr9tiAn5FomKmNSTLy8Gg7B41g04V39DLatcbwdWsIQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519315; c=relaxed/simple;
	bh=+K/PolHf20ghWCB0E8aQv5OnAwl4AIEKdX7utssQh+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uf5nrtdyZGaHYeLziMoLpEEOGUQA/bcmqtdqCOluubwJefq/pKNmg8w1ucVc7matvZGiRDzpdqWzJ/1A8n0voIbvWg5gnM+3RVchifsymiYSmxKGGgN+M8LQtke5W3i7foiX1ih+sYDgR+KaX0rB+A2TCWVDDRrSQV26c43FYBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=FE2vSemL; arc=pass smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="FE2vSemL"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e5cb052edso50516285a.2
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2026 07:01:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783519312; cv=none;
        d=google.com; s=arc-20260327;
        b=LWCPtFgHZDCHsYLVh7vos2sm1iFH9Zd4MWexnbIeJ4FiaKvA3UZFaq5wp+WTP7x/Gf
         CDHKig3OsGC87NeQg+ROwulpgKFmSIiKCSrVzrooyRqxVviJS5mLPheMql5U+lQ/15mM
         c9Fta9o09jku6vSZuSOVJy60yF3oQlLP7ofWxuj3r5/XKVUSsQJ9wNvRiZ2v2KmXTbL5
         06YnL9D+c5jNtCnzy9DlfQjGSU5Mf/SEqrjHlR2RFGjI4fAz94luY5fI3UlqiM7BRRwq
         NatlghEuVQM2Oaf85uwxFrygXm5CS0XQN/Ap3GXeDqSoiZ+XSicVScnQXJ8wtk4ul7bR
         ru/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vWkMP6ENo0m0i33Nu6yUk0oefbASMwJB/eCX2aKtZUw=;
        fh=R+nz6AlWWFjJMiP4GPrTS4pUwn5rEkudd6PZEKrs6b4=;
        b=gklBekKM6yb3TGE/TK/XvAbBMV6aDBD+WLqH326Le//CYssq0J8Dp30QRAyn8yo6DP
         GOgHAkSnBmqpicme6cpValgnBL1vcdh7lF/WuUu85RbF3+JWiuIr4n74NXTrq5tHsxwk
         KpAqMq46ljJgp49mGjM+6f2VJkZmeYbb/M8/KVr/92IsKzhfV61hZFLRSdHajJmJfpDK
         oQQWSq2q307DP/7Q/JkEp857W/Ym783aLXMyeQfnPz5jaqTts+igZdxH6ViANQLQ6h9D
         H/WfcLRYjf58uUNZl4GWxfzkAHvBgTyqQ7lSc4NEulVloYHX0E+9ex6D8UhfY7mvQ5ck
         RcHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1783519312; x=1784124112; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vWkMP6ENo0m0i33Nu6yUk0oefbASMwJB/eCX2aKtZUw=;
        b=FE2vSemLBR4DA2u3DKo6sacRgKuvHvkma6XfKcwJXzklAe1ek9iqdilGqwArjhLmO6
         NfUwhi9buKzf3KcIXJNhaoIipQ/Q//VznO1yHOG2GwWTkpoB1vXxN33U8GwStJMknial
         GV5fNfjwGNotd8h14zqhvEISgWggwevQHua/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783519312; x=1784124112;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vWkMP6ENo0m0i33Nu6yUk0oefbASMwJB/eCX2aKtZUw=;
        b=oHf7GKCHWHyLI1PceBkc6eZHjvzeAOEUnsluF59hADYNnCAmkybRcBgwcM+9pJ2XvD
         j/BDOjtgZWS4Bex82Qq8tdZ0hofS8mDvC3u8AuqB3DoJrfckxbnH/jBo04R28cBbxH6C
         zfqCZXIOwjRheTJNU2iLjmSU+RnSdU0RCwfCgsGAnirwsZWO6xTf9J7+EGtdhy24A0l4
         vnHWijo0f144Y3JclpgsJHgCrLVJvXrApzPaNufNMFjXgv94PqfZJup07I/AnaZLzelQ
         RONy9rRw1ISO91lB+VBn2QDnUnKkF+IEukNnKB3+FkxStZdW6he/miqELQdyrg4TEvvY
         BmYw==
X-Forwarded-Encrypted: i=1; AHgh+RqVfGwP2Uaaw+TDg459eqrUyfopb1Qp7C6yg0BRG5O21Qhekcv0B3rGqf3uY/fOmK4xnuaxqpQcTB5q8IEw@vger.kernel.org
X-Gm-Message-State: AOJu0YwBAyu/E3P7mo9L12E27vkre2JhfD+Et1Bmc6pKggtG6JPTCfwd
	URvp6f8uWQme5kgsLxNdwN4i+u4GvCremYDTAM9qjfHzCCBul9QMM5ogQwaGr9D6TUumIeoDucr
	SWgpDO92SplpbGUdf+qt8WzQgCvGAtbVhnz2xl1VoHA==
X-Gm-Gg: AfdE7cmIoQo4Sg73b2UofI6GWDJWAsNMlMltz84XjJLgRNaHFmQnT9S7sjRFZSf0HaK
	AIPUzBLDiI2TyQA1FJzIdvQJ4gkMVCbhBhLHUs9UikKz2d0PX3xZsdQfGQQeEOkm0fVYDJrCOWk
	Uqz4dhDkwgTmtoklgMxZrnUNsDYKeX9n1UGlWsuaN7vhk7rh+92ntqo+h+gW4CSDH/m4PpES238
	zD7U+0fM3rMjGfd7dsfrGPZ1KuUheP7GJOQ86P+jaokAgap5d1AMsNSckhVM58QbTfO3xgrLOID
	goCsZx7YftdxtVQd3KjVG4wxCzx/PrhcHsIY+Q==
X-Received: by 2002:a05:622a:134d:b0:516:ed02:c85d with SMTP id
 d75a77b69052e-51c8b3993eamr26471751cf.3.1783519312028; Wed, 08 Jul 2026
 07:01:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708095831.3381978-1-gscrivan@redhat.com> <CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
 <878q7l8y4y.fsf@redhat.com> <CAOQ4uxiiVsp0BsdqfH3rCrpP6fBi-vTyfXd-TcVmFcS34MxzUQ@mail.gmail.com>
 <871pdd8ukx.fsf@redhat.com>
In-Reply-To: <871pdd8ukx.fsf@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 8 Jul 2026 16:01:38 +0200
X-Gm-Features: AVVi8CcKoJxcOuex25eFuQjNrcac3g1KeS0qxI4UBoIPpSpnnYXfivqBUUnrS0I
Message-ID: <CAJfpegvtd--TEQP9CVjSZuosU4meELdzhTV9oFo6joR1f4Dpgw@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Jul 2026 at 15:44, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
> Amir Goldstein <amir73il@gmail.com> writes:
>
> > On Wed, Jul 8, 2026 at 2:31=E2=80=AFPM Giuseppe Scrivano <gscrivan@redh=
at.com> wrote:
> >>
> >> Miklos Szeredi <miklos@szeredi.hu> writes:
> >>
> >> > On Wed, 8 Jul 2026 at 12:00, Giuseppe Scrivano <gscrivan@redhat.com>=
 wrote:
> >> >>
> >> >> Add two ioctls to overlay filesystem to allow userspace to retrieve
> >> >> information about the overlay layers:
> >> >>
> >> >> OVL_IOC_OPEN_LAYER:     return an O_PATH fd to the root of a layer.
> >> >>                         arg =3D=3D 0 returns the upper layer (-ENOE=
NT if
> >> >>                         no upper is configured), arg >=3D 1 returns
> >> >>                         lower layers (-ENOENT if index is out of
> >> >>                         range).
> >> >
> >> > We could do this with a plain open() call.  Something like the magic
> >> > symlinks we have under /proc/PID/fd/.   Question is where could thes=
e
> >> > live...
> >>
> >> is there any existing user of such a mechanism?  I don't see any mount
> >> specific info under /proc or /sys.
> >>
> >> >
> >> >> OVL_IOC_GET_LAYERS_INFO: copy a struct ovl_layers_info to userspace
> >> >>                         with numlower, numlowerdata, and has_upper.
> >> >
> >> > Isn't this info obtainable via statmount(2) already?  If not, it
> >> > should be there, instead of a specialized ioctl.
> >>
> >> no that is not exposed by statmount and I don't see any way to export
> >> file system specific data through it.  Do you've anything in mind?
> >>
> >> >> --- a/fs/overlayfs/ovl_entry.h
> >> >> +++ b/fs/overlayfs/ovl_entry.h
> >> >> @@ -35,6 +35,8 @@ struct ovl_layer {
> >> >>         struct vfsmount *mnt;
> >> >>         /* Trap in ovl inode cache */
> >> >>         struct inode *trap;
> >> >> +       /* Keeps the original fsmount file alive for OVL_IOC_OPEN_L=
AYER */
> >> >> +       struct file *origin;
> >> >
> >> > Don't need to keep the file open: the only info missing is the
> >> > original vfsmount, everything else is already there to reconstruct t=
he
> >> > file.
> >>
> >> I didn't manage to get that to work.  As soon as the userspace process
> >> closes the mount fd that was passed to fsconfig, the anonymous mount
> >> namespace is destroyed and dissolve_on_fput sets mnt->mnt_ns to NULL.
> >>
> >> So whenever I try to use this mount again from userspace, it is not
> >> usable because the mount namespace is empty, causing check_mnt() to
> >> fail.
> >>
> >> Do you have any suggestions on how to solve this problem?
> >
> > The suggestion was to store origin->f_path->mnt instead of storing orig=
in file,
> > because you only end up using the origin vfsmount.
>
> the reason I am keeping the file and not just the vfsmount is that the
> file is what keeps the mount namespace alive (preventing
> dissolve_on_fput from fire).
>
> Should we export open_detached_copy from fs/namespace.c?  I've not
> tested it, but it might work.  Are there other ways to solve it that I
> am not seeing?

Using an anon namespace sounds good to me, that means the original
vfsmount isn't needed at all.

Not sure if it's okay for the case where the original ns is not anon,
but we can save the vfsmount in that case if it turns out to be a
problem.

Thanks,
Miklos
