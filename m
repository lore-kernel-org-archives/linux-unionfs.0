Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043083093B8
	for <linux-unionfs@vger.kernel.org>; Wed, 24 Jun 2026 03:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782271755; cv=pass; b=Y71Au4wGqbJFqBHZUIM4U68LOU21d81UMnCwwyY2YjQgYrf+MQ8sk5+TWFcghhomQhwwJaqLMNUp+vlfEv7SbO92VfFhqpr0MzkrbfJg7GSATBlOMx9KPOpzsddhcU0AMcQdpQrje8SMGFtKyVLmFVPzvPA2u6Z7oI/6oZ9SpC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782271755; c=relaxed/simple;
	bh=67HFPOQMraA2IF9L6T7Ay7iDPKcTpVfUYIllTU0wk0E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g72xp92/Rs4IBWSUkqeEt4mEq4z6zC6++dDoEadUdDhu1OudXylsZbqIEe2xdTe8ku2DwJJJTQ8vcHVIG9ChNkuyd6hk0Y+7Tr0fSyMWIPLBeSEYLOU7cxgbFlhWfEAPWRWofgaB4YCXm2mVlD4rx897CfjxB9ITy3pBcOcuANg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KmNCwazg; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KmNCwazg"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-805f5d1a6c3so6015067b3.1
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 20:29:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782271753; cv=none;
        d=google.com; s=arc-20240605;
        b=PEY+//gaMTDp1P54YxZPGGUK9UHJb08xLVVSUG9fG8Qo89/q9LciM7HmQHRCFhWIl3
         wK9vibfCsj1izKqVXp+wTE7C4t27dNDpniY2HiEunDi1IP6FxJxh2yam5dKbNPft3Zw1
         oOZ9+AFjpqxwSKpXCoM4VoBjbWUUxY5EN0uHKx9R/fCW8rxdriETE//Mw6KBpSx0m4xW
         CPzLhxHef8cNMZVwDmiDeZHKPX1sBWXRb9yVYkJUphch6rPo2f2xujguT7uPKbbv1Zac
         VDUt4NJFIBsZa2c73RNmvcUoWcJASsZGiqQHnF5Qpy1HJHLRkcwIG4luF2PxXqO8ZoG3
         cnjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k9w9ybFX1EjLq5kZ5i9aFTSKQ0ykzW9QyuEa4uAxGDQ=;
        fh=GAGnnlbbmS7z1PcYDDrm0NzPIIVKRoSaEIW93yB3Mmo=;
        b=GvCcEJ4RzkhxAnzBtRrXO4Vn4BgSPTb6BFUER20CgsmRUD2FrB8sPI0mCpQhF5RTDs
         EKjMNGQvSE5+0I/wDsyD0CFE/EHkPJRkIvzp3NzsKCOBhFmYZRu5Yj4RNtxgMt6Q2Zn+
         jyVoMGV8jyUuyr4yFLBMucf0JyKjzODn/P9xRlibWSt6nOJgbKjCSMh4JxR6zfQ0a5V6
         pukw+lmpLr+shMvuklFTFT1wSkWg2C51NNkytW5Vfxwcm+eYyNHSCCUfY6elkEVyYJh7
         sZMk5CespQmQH7Tj2OMLw2NZt7IVJiDwuOmLnCDteRoVUXLKcOYoGHpYaelrR+JAehYI
         CJFQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782271753; x=1782876553; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9w9ybFX1EjLq5kZ5i9aFTSKQ0ykzW9QyuEa4uAxGDQ=;
        b=KmNCwazgksGIARY4hmn75AM4DanJgR+5VcYfzD4nPV7fLf3q1BSktQvRgfV0FmdlHB
         2hWAuvkyRYpvPl/Sei3ejnL1NKA7ycTULnB+wzFAsHKKmeaxG/a9UsmDl2N4K9DnNYdr
         UT/9jbVHlfgnYzif+f+qFhVDUE3CsKGIGYwyFEr9NS9qk/xipL3mxP5KFIw7GBG/aeoI
         YvDIWuwoYvv9GAHs2yOSiaQkvxIoaljMsa03V4b/FSo0CeBNgtFYGzUawx2x+IedH+Pa
         E3M7UEim3Rb8flluqVqyrzlGSZStYv4qK8bJO7Lvxz7qfxPhrdCk/Z3bUBVvd9pKVqG2
         XpbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782271753; x=1782876553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k9w9ybFX1EjLq5kZ5i9aFTSKQ0ykzW9QyuEa4uAxGDQ=;
        b=bfx2PhkNwrInrTZqEvKnr379tWt+R09Nofg3jSz+T5zli4TVMWRaJNMgFg9Tzv8MiU
         aUP534sZ/DyiJyLTnUIQNLTSu1y1Sz4CdSv+urYuKWER/+mGUSTZIFV7+7nGGcJOwgws
         bMJLu0SqMngynQpoSF8sKIjOyH1DRtbIVXyfcU+c0JD6ucTE6LkcOF1jLFAfg4zVuodq
         Fp+zchMGW3IWLdFoZ1lzGOn4cnYLu+JSZaXikobA2pX/8Wjq51T0wE1S3x6cddhI31kk
         USgr6L1UcBeWvOYjozCrtAAfo4ejvkGpQcc0MmeosotEiTBtsrb5E2oKI9aynqeURNWS
         XEkg==
X-Forwarded-Encrypted: i=1; AHgh+RpmNtzzPAag/Cl1q37HrhobIKQpBEYvCy57HK8H3mKFU9Jio5EGZQkQqH5WGf469B4boGIXiu+Dsi7/HW/g@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+kjv/dAvlNl8UURGTDlFbis5BJCwgsXpzttNxYMQSR/raBVU0
	p9wRHHR5hahXpxNxSIbA+zFxFUdZzGg1u9Osnocv38AU3rig7YiWC6yuwGhovi86u/27gh+VvaG
	u61TN4yWfvTOYimtcr6E+3JXFCMF4JM8XxRpdlOo=
X-Gm-Gg: AfdE7clWUW002PdLaVUQSa0XB6i6+C3PDWkKmECKoCU1tJydY2yTvwnHuLkDLgtQT23
	fu913fKgH626UxIQDY6Dnlk496VueqQBI1KGj1FEB0wINkG20TWUyLo1C3eSuCe4tyMzomKa2BF
	O+Jz7+n26L9tehtzLoKvrpTGvbNHcklXgTp5wgAUV92ohN0oX4+h2ntYsW4ulW2QDELYj+cuu0t
	E1WN3M7BKEVl7/DvJSF3dRcavNoDde1El14VGiGjUoMVT1+NfwHKJ3MKaP3vRowpZmdn/FS3Zg9
	FiG81hgOI3tgEK+PmoNysCvnYwXrkQ==
X-Received: by 2002:a05:690c:7342:b0:806:8eaf:cf1e with SMTP id
 00721157ae682-806c2e4df8fmr56909717b3.25.1782271753102; Tue, 23 Jun 2026
 20:29:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
 <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com> <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
 <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com> <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com>
 <13bb8cba-c82e-4a41-aff1-0a6418873bf1@linux.alibaba.com> <CALOAHbCkbSBVqUStUbWB=4vUUOEyB63yMsXvS_cZUZOwr-nmew@mail.gmail.com>
 <a5a1b56f-0b1a-473d-8fc9-8cbfba85813e@linux.alibaba.com> <CALOAHbCrvbvT04O3v+p-CmdqVN2BGJYKj6F7we70kPwbs-hmRw@mail.gmail.com>
 <b4d43064-7a7d-4d65-b65c-56e80d47ed17@linux.alibaba.com> <20260623134240.GA7980@lst.de>
 <1cc0931b-648e-4baf-9667-742175b3f9d0@linux.alibaba.com> <CAOQ4uxhURfuQWMd3y_W1iFebJms3aohn+koy5_sjxbcc4ZBQ-w@mail.gmail.com>
 <CALOAHbBjhqKZPqb9r8qoUoYfzpEe6wYU9By_cZtuGGmnoaAa5g@mail.gmail.com>
 <f650bed9-b049-4576-bbcf-6dd46028c5a4@linux.alibaba.com> <CALOAHbC=2AvZYWEUXR9bk2s=2jk_sVK6zimes1H-TK3iFnn_qQ@mail.gmail.com>
 <33912eb8-6b2c-40c2-b698-837e3f675d61@linux.alibaba.com>
In-Reply-To: <33912eb8-6b2c-40c2-b698-837e3f675d61@linux.alibaba.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 24 Jun 2026 11:28:36 +0800
X-Gm-Features: AVVi8Ccywfv8INUcKNw9ZBGfqnyagnG08Ez-eeCcHS_qs6k1llTDKaKEY-xs-s8
Message-ID: <CALOAHbDrWR0eRF9gST14Vm3xOimDZ=iLdn0zRFiF7OeBtqOD=A@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: conduct@kernel.org, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, 
	miklos@szeredi.hu, linux-unionfs@vger.kernel.org, fuweid89@gmail.com, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	derek@mcg.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 11:17=E2=80=AFAM Gao Xiang <hsiangkao@linux.alibaba=
.com> wrote:
>
> Hi,
>
> On 2026/6/24 10:30, Yafang Shao wrote:
> > On Wed, Jun 24, 2026 at 10:28=E2=80=AFAM Gao Xiang <hsiangkao@linux.ali=
baba.com> wrote:
> >>
> >>
> >>
> >> On 2026/6/24 10:09, Yafang Shao wrote:
> >>> On Tue, Jun 23, 2026 at 10:52=E2=80=AFPM Amir Goldstein <amir73il@gma=
il.com> wrote:
> >>>>
> >>>> On Tue, Jun 23, 2026 at 3:47=E2=80=AFPM Gao Xiang <hsiangkao@linux.a=
libaba.com> wrote:
> >>
> >> ...
> >>
> >>>
> >>> Since the "volatile" option has been working fine for over a year
> >>> across our large fleet of Kubernetes production servers, I submitted
> >>> this change to upstream. In Kubernetes environments, there is no use
> >>> case for remounting the workdir to the same directory, so the volatil=
e
> >>> file won't cause any issues =E2=80=94 which is why the "volatile" set=
ting has
> >>> been working well there.
> >> That is not an excuse to introduce such new incompatible behavior
> >> to the linux upstream starting only for your customized fleet and
> >> bother every single opensource user/application to adapt this
> >> behavior which uses overlayfs now.
> >>
> >> If you insist to work on a breaking change, please gather
> >> userspace feedback boardly first.
> >>
> >> And here I just say you and your employer are lucky since I
> >> know it's also risky even on the generic kubernate perspective.
> >> Please just maintain your livepatch downstream, thanks.
> >>
> >> No need to reply, and I won't reply this either, it's just
> >> waste of my time to explain a basic upstream principle again
> >> and again.
> >
> > I'll just go ahead and redirect you to /dev/null ;)
>
> The whole thread is:
> https://lore.kernel.org/linux-unionfs/20260623084337.54344-1-laoar.shao@g=
mail.com/T/#u
>
> Personally, I feel offensive due to Yafang's expression
> written above.  I keep maintain my replies in technical
> discussion, but the replies above already include the
> following words:
>
> "No wonder containerd is getting harder and harder to use ;)"
>
> "Please do your homework."
>
> "Again, pls do your homework."
>
> and the emotional texts `;)` make me feel uneasy over the
> time,
>
> especially the final words "I'll just go ahead and redirect
> you to /dev/null ;)"
>
> So I write an email as a public report to the CoC since I'm
> not sure how to proceed to comment the community patches
> because I could get offence as a result.

I believe you could learn a thing or two from Amir about how to
comment on others' patches ;)

--=20
Regards
Yafang
