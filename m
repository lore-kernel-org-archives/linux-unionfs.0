Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3979C2D5A01
	for <linux-unionfs@vger.kernel.org>; Wed, 24 Jun 2026 02:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782267036; cv=pass; b=uK+/6/rihjJAnMl/6D8MgWCDxq+UuDbvL43i4+BRr9fV/l7h7oXH45Wl9pt45JPWgLKR9MLf9rpvtMG8xUczl3lrHT5671jg7Wa/SARd/aohyKnlHkGZjT+m4jpcj1ZtRF4o96eFFFA4G4uMdnpQPS4cCaWVgNBLJ2vt5rfvaXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782267036; c=relaxed/simple;
	bh=Hyys1Ipja44ZETCJzzZPr4CAwUCrk9wa/Gjlr6+gwEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qToXNaI80saXTS+Bhg/wMOsOagAkuA6Umv6vX6KcDGzPKYj6EKVPwp59jonOMdTFqlOwH80Ed/w7HITi/bBChE/V3p+KM2qRoAnxQdp90E2h8nPmxazKXAUsh1jCUr5iFe51jz9VEoHEiRy5lLaKwMePURagW5v0ToiSQOtZGr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMHw4e1w; arc=pass smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMHw4e1w"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-804e46366d7so6063257b3.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 19:10:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782267028; cv=none;
        d=google.com; s=arc-20240605;
        b=jIIBAoybn3mFqzyO2+69Ct87n/6MsqBEO50STrdQG+cE9EPKMgX0DkS0X2d9HUobHo
         R9TndQMMw77DEKXv/Cini61MogNAy8DzvcYx6fiaa/laqi1lc33ykkm5RnGWwCsglZVM
         oJqcHaX8Ab8TnNSmzQf+Qz8g1hJDKl/BJEdnnquIXM9r7Ib3WHkDEO0WXUIt7ORVawv9
         zH9OejphmnoojypQTooF19Bm89gROQazE5Sb00j1OtNGhCbz9+CIAeZUTJfNTnTBsFrA
         M6X64oUpjs2X9AK9FpM5foltAg5l+iGOWrdFs/qQ171FsQQYdf4hOS3wXCvcGq7ZR5x0
         Omhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/hpWkQ3db+rIuMbgjWrz230E/QWkRcXteW0x+sa/s2Y=;
        fh=SCfNgpUW+hmTlyNPMTrA+DtlSc7DgbfGgvul8iOA1OM=;
        b=J7hjLYMeUQBlSpDZh5onb4N831cmKGgJ7G4EPO7VN8B04RKf35hFsD0MuDSpS65vKN
         mRjxwNoXNymcxZq+TxVEIAUhRNcaWomrR7+nSnMq7vhJXs1BzXi7X6rVIu6EswMYr9ry
         SOj/c5V35LcbqVhYTrmqTcfxhiaPU1v4tRIG6FVibhn+MuULzD8tt02SHB4v6I+ae1Fk
         T/yceuwYNPVhjEQLOqyjv9zoQmfbPb2IGfKIPRjfnLmP8ZJryXPtTKmsXdBns5ofl//X
         9rR18wGYzhHMsslsOGJ/PnnuyQ6k75BlR8vSXigFN7EeV5H8RLwxgbXNjRFVwb1wgJ6e
         ZAVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782267028; x=1782871828; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/hpWkQ3db+rIuMbgjWrz230E/QWkRcXteW0x+sa/s2Y=;
        b=eMHw4e1wGChWpk6+ip4TNHupbqGldeeA9V6L7JaCdAvXqv5MLK/OcmZnUzvVQPlLnV
         ZI7DPq+Duh1Zm86hEvkP8Rljmw9Zi36lENhERRe9z5pWqXd06H3P+EyHCWdN9DhK6Ti1
         mJA6p5Trnq0UBnZ1KX7RtjDNNDTa8lq4kEudf7XiKX6Fc7eYFUzIf8vZI3iOwDyKm3sM
         23Whtk+AyxjA0N3s2dYBaj4A3nYwM8thRqXF6uZUJOZqjJzUHtkZMLZQxBOhyq05erQZ
         Y+1wx3sTEYhT+dVwhJRWHuZ7RdP75aPqCuckiOCLH32c/3jabaXxIB1I9vRetSr07wgv
         fNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782267028; x=1782871828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/hpWkQ3db+rIuMbgjWrz230E/QWkRcXteW0x+sa/s2Y=;
        b=BjV/UO/2aKZr2IcEMqPhaFviU4M7kltekzCpGH4ExRFUnHOrx+DRaAjugcfQsYqJ+R
         kpElLW4t6yr0BIALZ8zNwoDvEO0t1AqVHUDYbqDsLG83T8mBTp4f/2HeSuxxL8naf27K
         U1zNW1eJKT3CBXQIRfRQcAClG2LLKvm7AlAPwFSp8iKY6Rrxrp4/DLGsEfmQdscqBpvN
         16Y2b2UAPj4qiwTq0JBL6Z8KEtKM8yCS5kYUNQXiD7ACGJYARh0wOmY0XMs+nwQ/U/Ev
         mdWW83g5xXOEeIUwcr4kfxpP2jhTaCmqu17xpoQ5PaXU/yj0maC1aL77rlE+tfGZt3Jp
         GuFw==
X-Forwarded-Encrypted: i=1; AHgh+RoqdrJ1sSw7PHU421GNhZblVj+FC4kf2d7Y/s5WXyRnsQ4C33+/B7Ov8D8OUISJSw4cyALl1JSFU9oebDVp@vger.kernel.org
X-Gm-Message-State: AOJu0YyW2ee7VZElXGVHJDNhL/mTxxMnpT5nmwNJCO/cgkZttuTxKs5S
	lzZKAGBn8cJGPbM2gbhB5oOXOkKiBB2LheVtiCiUX6+bxVekqGGdz9KS0Fsw1rAXgpJp1ipwL1n
	RLfSPYJyoUq1KjX1AkndzuqC0MnSiU2Y=
X-Gm-Gg: AfdE7cnUYI/E8j9bVK5P7TsLbTF7ogW/0mLcUqNOB4LgZ1EoeKtY1l/72DmCyJH8oCo
	MwEER8pwFTn39htudOe9+vgM61qLZ3GN55RX5+/LY2Q6PLLusiOdu+2opkvOR7f16JXQTIEHo0e
	lkFrlfpyHA+pptk5t3hp38u4cfUA2NpmnNA1GY0y9mMetnXWm6BdoCqX0LiXu79kZlC3EpQF07H
	1e5gVjDWm2YSLgbfCbBQqB4pj/3ivPWUQAT5CpyuVnLoMoSAEofeCr1yQCO2SBk9FQRx0oxx401
	kl7bupXSIEY/E2f5srID5NhrmcJQQg==
X-Received: by 2002:a05:690c:4907:b0:7b2:dad2:5dee with SMTP id
 00721157ae682-806c177a9f0mr58536407b3.2.1782267027945; Tue, 23 Jun 2026
 19:10:27 -0700 (PDT)
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
In-Reply-To: <CAOQ4uxhURfuQWMd3y_W1iFebJms3aohn+koy5_sjxbcc4ZBQ-w@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 24 Jun 2026 10:09:50 +0800
X-Gm-Features: AVVi8Cer07k7JiJRn4LHXFU3JXvVhciQ6v9ASZ_pH_p-I5Ma4JXr_5Lx0Fia6hM
Message-ID: <CALOAHbBjhqKZPqb9r8qoUoYfzpEe6wYU9By_cZtuGGmnoaAa5g@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Amir Goldstein <amir73il@gmail.com>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>, miklos@szeredi.hu, 
	linux-unionfs@vger.kernel.org, fuweid89@gmail.com, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 10:52=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Tue, Jun 23, 2026 at 3:47=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibab=
a.com> wrote:
> >
> > Hi Christoph,
> >
> > On 2026/6/23 21:42, Christoph Hellwig wrote:
> > > I have no idea where this coming from as I can't find an earlier
> > > version in the fsdevel archives.  But changing user visible mount
> > > options through konfig options is simply bonkers.
> > >
> > > I'd also like to not that the submitter does have a history of crazy
> > > patches including those to support proprietary modules and then
> > > attacking people criticizing those patches, so I can only suggest to
> > > every maintainer to ignore them for their own sanity.
> >
> > Sorry about that I didn't Cc the proper list at first,
> > but it could be checked by using lore:
> > https://lore.kernel.org/linux-unionfs/20260623084337.54344-1-laoar.shao=
@gmail.com/T/#u
> >
> > This topic is very specific to overlayfs details, I'm
> > not sure how I could say the background in brief.
> >
> > But almost every single container user uses overlayfs
> > now, so in order to be responsible for end users,
> > container runtimes and applications, I used some
> > aggressive way this time.
>
> Gao,
>
> Thank you for holding the fort!
> and for foreseeing this containerd regression.
>
> I also agree with all your other arguments that "volatile" should never b=
e the
> system/module default - it is too risky - one needs to know what they are=
 doing
> when using  "volatile".
>
> I will respect your NACK.
>
> Yafang,
>
> I agree with you that your patch appears to follow precedents
> in overlayfs, but I also think that "volatile" is not a good candidate fo=
r
> this practice, mostly because it makes mount cycle fail.
>
> Since it is so much easier for your employer to live patch the kernel
> than to upgrade/patch docker, how about applying this live patch to
> your kernels?
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index c93fcaa45d4a3..2105a51d12439 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -155,7 +155,7 @@ static const char *ovl_fsync_mode(struct ovl_config *=
config)
>
>  static int ovl_fsync_mode_def(void)
>  {
> -       return OVL_FSYNC_AUTO;
> +       return OVL_FSYNC_VOLATILE;
>  }

Thanks for your guidance. This is similar to how we handle
livepatching, and we also implement the "volatile" option for
already-mounted systems.

Since the "volatile" option has been working fine for over a year
across our large fleet of Kubernetes production servers, I submitted
this change to upstream. In Kubernetes environments, there is no use
case for remounting the workdir to the same directory, so the volatile
file won't cause any issues =E2=80=94 which is why the "volatile" setting h=
as
been working well there. But yeah, I respect your decision not to
accept it.

--=20
Regards
Yafang
