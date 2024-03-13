Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11534487A7
	for <linux-unionfs@vger.kernel.org>; Wed, 13 Mar 2024 19:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710359448; cv=none; b=Df29CH4zlOIAgw63mdEq5vXd2FRq+MsW0EtDZnsxGrVjRzNZgnSJTlylgkuHvgSDIdRyCocq0aWeXaCY7h9DRfk+ZP0C3rLWMU8bKejw/fL7+qz7yoqFSdYi8FrujT+LGt0Tg7IEO+pVZS3yj4+8HyVD/XUlxaMzH5BwPQ1AHC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710359448; c=relaxed/simple;
	bh=nAzXeq+jSO6MyHfHaEZr+agFCJpywpvPrgO2VkhEbRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sp2qpwkdKTHPC8RP0ZslbSuC6eoepP6aI00YABmYjcKcXxeLGtPkU/8zlJBtv/gGJbS+cjV7pmhVep5oJcNjDpLwCx3JuFNEIDhnSdFHQfYIlczMZlxyDcV3f3EhsbuoAeCBLwHNlLCNAjkwVbCZdn0fAWzK6X6kl+XS4qLI62s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kHKtivz9; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kHKtivz9"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-2204e9290f9so144747fac.2
        for <linux-unionfs@vger.kernel.org>; Wed, 13 Mar 2024 12:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710359445; x=1710964245; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nAzXeq+jSO6MyHfHaEZr+agFCJpywpvPrgO2VkhEbRY=;
        b=kHKtivz9nxPQNDqbCu9qj+AC3+JRmYH+x4xurGUOBZMVnC+z5OE8YXAOxK06OSUQII
         ZZQoH72biH+DciwHKL17xx64IUcFK4amDuUljfL4wLDswylCcrAatliiBc/WY2wKHi9s
         xOzxf4jts96jZf5fJl66/LXuzXwOe3D3MCv5QlfbLaawcXSBnqvdGUPOqhPBpY1SefXE
         AqfTiAZ9sEbreL4UTIGDyNsBxBi43I5LY+gvA+7fTLlsXLnxmuHvrzYmanPhOr8BbCzR
         HIu4JFY9LhYqZ7cxKq+q4st/u2SKVF8Go6LAbKddfXezIEj6QI+C4WifoPb06nC68+Ac
         U/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710359445; x=1710964245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nAzXeq+jSO6MyHfHaEZr+agFCJpywpvPrgO2VkhEbRY=;
        b=CGdai9cliDwkVd3/baHISC63o0TXte0xkd3XoS67s9+qqjr84yeKcGXk5R3S0cK7vJ
         iTHQaLxp38MLmFcaNoX7QeMoib8EiD7WM1QN0P6gAeZvw7J2mHiFWaAwjMf3XNFL/t2n
         MABVcSm5rU9o2Jtz55tE9jPCHZe7GXqSkKvjSaTJprjNO8G5ukjgahXptVWuimWyVtml
         uq7hE8uWchCfI0tbgFd/IdgUuOtNUSIC1XoFR4u5peuOHfIa5EhwrS48rDyLW16r1mMR
         Y2K3oLZSEAxxMk2RhrbQZgHfDscvu502m/e1Fr6fzmD2/5/dDKkcOh0Qv/mGeW8gjXxj
         ddPw==
X-Gm-Message-State: AOJu0Yz/ZGAXdMTAIs1rkb7fugrUNDfD4rdereD6705Y+TrBvuCL2r9h
	KHeW4jbCahm6bjWs5VrkUHqgkE/iTkFcfRs427yejbArdbcCiYBiJxubfkynNabPFyZPL7FBvLe
	rA8vAJqgjazt/LgTYq7Z4RNj3RgwlXhSjX+0=
X-Google-Smtp-Source: AGHT+IH+sCVgXKeCTo2lwAn7ddsEmHERIhVqLVLaNhsNj20t87UUWFH90JMQdGDtd7Muf0nZ/QKZ6vLEulO891ATbPA=
X-Received: by 2002:a05:6870:7e14:b0:221:c8a9:563d with SMTP id
 wx20-20020a0568707e1400b00221c8a9563dmr12180735oab.3.1710359444590; Wed, 13
 Mar 2024 12:50:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHQZ30BFHkt-D65rbxE7MspurQKD8kw2bK2HKxast-RN8ggKfQ@mail.gmail.com>
In-Reply-To: <CAHQZ30BFHkt-D65rbxE7MspurQKD8kw2bK2HKxast-RN8ggKfQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 13 Mar 2024 21:50:33 +0200
Message-ID: <CAOQ4uxgL8isH32NK5WtbQjPudrtG_MKecGB+j6VBHmb1K0jzyA@mail.gmail.com>
Subject: Re: Accessing bind mount in lower layer via overlayfs
To: Raul Rangel <rrangel@chromium.org>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2024 at 8:13=E2=80=AFPM Raul Rangel <rrangel@chromium.org> =
wrote:
>
> Hello,
> I was wondering if it was possible for the bind mounts created under a
> lower layer to be exposed via overlayfs?
>
> I have attached a test script that reproduces what I'm trying to achieve:
> $ unshare --user --map-root-user --mount bash -xe mount-test
> + mkdir -p real/usr/lib
> + touch real/usr/lib/foo
>
> + mkdir -p stage/input
> + mount --bind real stage/input <-- I want to mount `real` under `input`.
> + ls -l stage/input
> drwxr-xr-x 3 root root 4096 Mar 12 11:53 usr <-- `usr` is visible.
>
> + mkdir work upper merged
> + mount -t overlay overlay
> -olowerdir=3D./stage,upperdir=3D./upper,workdir=3D./work ./merged
> + ls -Rl merged/input
> merged/input:
> total 0 <-- The `usr` directory is not passed through.
>
> I wasn't able to find anything that explicitly states it's not
> supported. Is something like this possible? I tried setting the mount
> propagation to shared, but that didn't have any effect.

Overlayfs does not follow children (bind) mounts.

It looks like you are trying to overlay the tree at real over
the tree in stage/input.
Why not use an overlayfs layer of real on top of the stage
layer?

Please explain what you want to achieve rather than how
you tried to achieve it, so maybe I can help more.

Thanks,
Amir.
