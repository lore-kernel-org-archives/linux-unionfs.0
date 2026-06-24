Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD282F7F0A
	for <linux-unionfs@vger.kernel.org>; Wed, 24 Jun 2026 02:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782268290; cv=pass; b=ANqZULs4LUi+cqj0S8zPAQUbTiooH6gC0h4cgDqmDf20jNqvIjYWpY1WamOIb9u1kXWIfSDx4izbssn2+HkQD68ZFs+prpGHZjzh3oOEbS/9oGsfG0iGAsM5ayfaYxnoUoD1V0JqKvNFGGLahMut5aYZgS6xYp0TcCoiWFlZaOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782268290; c=relaxed/simple;
	bh=N4POUWvYCLu0BsmCeg/Wl9VL15DujaVsb4Iw9Anbsjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hOcmAMRDinl6f1YUMjPod7z+8w5FnVTzcKxzXNBKNM3sE0RCaoHsnaCUZJKtAqghsp9jH4Bs20HH7TrjDCKhBHCqhjJxGc8zHzgfhiuiNeGKyOIzlnIwYnJp/xVOL8eTLXd4xnqnTNcvJlNtaj78xVVld+BuH88DbdL0vN4J8pw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gHtmqMG2; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gHtmqMG2"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7e1916922b9so7560077b3.1
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 19:31:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782268288; cv=none;
        d=google.com; s=arc-20240605;
        b=HnouP6HvA5BPoxdUKtq0XkobqvaCXo13o5dm+rjRGLW/Z5+gg3lrdBEgLOjCUxgrOT
         gXpGfQF4oMKApKTjCZ961CXao94hlbBn4d8+6xYDk20QuhN+DeT1kW/o1qX/MhWyGw+c
         cmbuv5pevYnZS3Dz2mf6subxa+trxbp9hfq7s8p3puuceMSFje3euDTRHwzt7P5bM/vh
         MbJ6mvBv5dJGbr0ALiSfFK+kz4lHceFbKvrItdj0dR0na4vh8l/bUt8ULGEBUkNUZzH8
         F/t/fXM3zUN5FmDFzSf9r9VdXZ3JtTcF1RMIjmknuJGydT2IwxEPZK/i+sBA2n3YIIQ+
         ikBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N4POUWvYCLu0BsmCeg/Wl9VL15DujaVsb4Iw9Anbsjo=;
        fh=2I71GO2Q7G8acgyjU1FH2ilSQFf9hyF0FVwCEZPqG1o=;
        b=N0hiWPIWBdEHVS3aaQYLCaQqs8PAlGOGhdemYYpPX8olWEhv/eWdKGXa/tWIPoPdQ4
         LAY++hi5KvyWIpuze53t6a+HxtNGLOfw1SRahjQi3l4b0Ept0Ti9FaTCb1CVRya6MGqU
         JvdR99OFiKvbykivPuBCA6wbSCOld23SoxzNALSZKfDs6CadjdFGpd109HbM059Jg+X2
         jV/LAN71vbMns+397G8sszaZAceE8/BjMv58cKvKTHUAtwVUSP+fGp/Wru4y7AYdO+y3
         iBh7KMq3S0VRawbVIUFSWp1kicDU+rCiqLjn554DB1TSc4UUyGEhf68HqenywcCJoaxg
         DkNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782268288; x=1782873088; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N4POUWvYCLu0BsmCeg/Wl9VL15DujaVsb4Iw9Anbsjo=;
        b=gHtmqMG2XnsHFZ4lIE/mN7pJeSH/KQwcP6QtOYW4vdJrRnFKFvOVr2s4ceTqyfmgCq
         3tmsyyw7+ni3k/t5HB1B91kBN44O5nmgMtyUGUC28M6fa5LYqd3NBTGXSsw2AM009+NC
         RVigESTEGCHqLOWqtBZNUflX7d6VmskF5aB9JN6YRVXzM+ybaRPBKPrucypebDQxQSFv
         dnZETmCVwLI6x1kwLXox8rVa676dG2Oof6xsJq3dnHuz8KxqFDr8HleRKl9t7pWHsnoG
         tDDwaN9c+oyKHu/WtAi+RAdl4ND1N14XOVZozN5lIfStuh3jXTSwkdjvN0yqoYGJj3Xy
         U1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782268288; x=1782873088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N4POUWvYCLu0BsmCeg/Wl9VL15DujaVsb4Iw9Anbsjo=;
        b=hVawbnCqNkR+NyXoiulGNj+pkR5nQGiTWeNoGm0qL0VB5qoRgNTF7FdcRqucIieQOC
         RT/MMcaM2VZOBNSy3jiSdE1MA2gDj4d5qM/pFO3mCTCmf/RhEsySmonOhdZgU5jY0qZ7
         yDwBuzK+N0LFBgZe0a7xBn0TcpW7Ni0PTEg7/dMGwcONkzjVRl8w2/31eSlGgx98rsIX
         bJQ/OAgGoyoSidUTDBvw69jBqolZoAEC3x2P0OqCL++U+R2rBqv8zs37Kz5d1unUpsjQ
         gkYJqfnP5Rdgou6mIR4+kcADbY445ItCUaz4leFWUcgBVyP9KNVIxcStXPSWYIGfU5Ny
         AI0A==
X-Forwarded-Encrypted: i=1; AHgh+RrepjWlMiWfUOpl2bZH3SCi9vZx4mIumUwWvBVx1nugqBydZ26A2LB46DpepC+sjHJDtbywrPy+vgLoFWLM@vger.kernel.org
X-Gm-Message-State: AOJu0YyE4gcP13hSo2XTu+EMumXI2Tv5nCcldA9tFNJc02ky1Ic7IOdT
	/q/ORFPWuLsN5dsHXjCP6IJS2D+K264+Y5Rul3uyc+9/v7m159Yv8EcZ+dvmgrgp7axo4CbQnrE
	JUR2VyfKHAhUIE8m6SE1F25echNLKyIwKWEPkkAE=
X-Gm-Gg: AfdE7ckOaxWITAwJBvEPEvel+2cdIVxYg7mvPNemT30Jul4LcRLsd4+XAHPUmIUbcMQ
	h33At6gUqTj7S1tmW6Gn7yk2KaAEnszOWiRI6s534DM2dIqS1AhGkoM4s8+tq8Q5DI/SvYamCOu
	Gh8Dne1SDrPTNzdQVfhEcQ/ZLksm1Us7ZKMwd9JArdzGoTE/ApywDcL7eeEpmKvsKtkJHZUE5xX
	nooOHMgOhksTQXlQ8rTWZVsLO2C0CA9Fyio3TDVr8nHgoNnn3deRQdc8ZdEpiGm7zS217+Wvkfu
	jaJ+fM5+vy6BIOxKpNwEoTKw6uvurg==
X-Received: by 2002:a05:690c:4486:b0:7db:b027:6166 with SMTP id
 00721157ae682-807f2be793fmr13876827b3.22.1782268288394; Tue, 23 Jun 2026
 19:31:28 -0700 (PDT)
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
 <CALOAHbBjhqKZPqb9r8qoUoYfzpEe6wYU9By_cZtuGGmnoaAa5g@mail.gmail.com> <f650bed9-b049-4576-bbcf-6dd46028c5a4@linux.alibaba.com>
In-Reply-To: <f650bed9-b049-4576-bbcf-6dd46028c5a4@linux.alibaba.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 24 Jun 2026 10:30:51 +0800
X-Gm-Features: AVVi8CfS2zoJV8luPHkguUpjQ2Td-WyBgnKGjQ4yu0nAqcn50NS0ZE5BbKknLmw
Message-ID: <CALOAHbC=2AvZYWEUXR9bk2s=2jk_sVK6zimes1H-TK3iFnn_qQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, miklos@szeredi.hu, 
	linux-unionfs@vger.kernel.org, fuweid89@gmail.com, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	derek@mcg.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 10:28=E2=80=AFAM Gao Xiang <hsiangkao@linux.alibaba=
.com> wrote:
>
>
>
> On 2026/6/24 10:09, Yafang Shao wrote:
> > On Tue, Jun 23, 2026 at 10:52=E2=80=AFPM Amir Goldstein <amir73il@gmail=
.com> wrote:
> >>
> >> On Tue, Jun 23, 2026 at 3:47=E2=80=AFPM Gao Xiang <hsiangkao@linux.ali=
baba.com> wrote:
>
> ...
>
> >
> > Since the "volatile" option has been working fine for over a year
> > across our large fleet of Kubernetes production servers, I submitted
> > this change to upstream. In Kubernetes environments, there is no use
> > case for remounting the workdir to the same directory, so the volatile
> > file won't cause any issues =E2=80=94 which is why the "volatile" setti=
ng has
> > been working well there.
> That is not an excuse to introduce such new incompatible behavior
> to the linux upstream starting only for your customized fleet and
> bother every single opensource user/application to adapt this
> behavior which uses overlayfs now.
>
> If you insist to work on a breaking change, please gather
> userspace feedback boardly first.
>
> And here I just say you and your employer are lucky since I
> know it's also risky even on the generic kubernate perspective.
> Please just maintain your livepatch downstream, thanks.
>
> No need to reply, and I won't reply this either, it's just
> waste of my time to explain a basic upstream principle again
> and again.

I'll just go ahead and redirect you to /dev/null ;)

--=20
Regards
Yafang
