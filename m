Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3D030DD0A
	for <linux-unionfs@vger.kernel.org>; Tue, 14 Oct 2025 22:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479468; cv=none; b=RcUpT19FH9krCOppSB+ev7O6m7EGJqfCm6i7Zr6NoRqZ1MUVkc9zqCIlFEySdzkwjK4n1/ZJB4KNddB6sI8xTgZcdBM+6Xd/OIS0RfXGNXPjYf3LCkm2gAqliWEM7eke8uLpLtonNjdRLKejqsU8xtSPhWs4x3292wx9B8A1UQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479468; c=relaxed/simple;
	bh=pG515i7syHG3vED4MTNqB/DberSEKkguAtEkJvVagCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Id/DVwqv/5rXHu/BWfqCtqq01Dp/RgQMP4+6uEHHSmNaUGPN0oRdXM3qyWKMl5+lWwM+8eoNiju3zp52I/EvB1cQ3mThRojAb4nkQG5A+fjCFVbi7XhD3GHGDyAYBteSSNJe+5UQ25q+n7PZAByYdMP+OwunJU5/cZ4Vwhcbe8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BuXT4COZ; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BuXT4COZ"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-789fb76b466so5400500b3a.0
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Oct 2025 15:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760479465; x=1761084265; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l6XDsENWGoamE2lQfBoeAOTQv2/NbQK1cLV8RQTx+rU=;
        b=BuXT4COZt833j/MT8p8ax319LGdRXi0b/KO67c7Av6vdB9shb0wEtOhRxuuZN0iHrr
         J1bcKGTvyVVFMRuKd5Vy28WN1lebSZeI3E8/nKnN1WKAq/m1E4mF2qIY+2ZWRqcB5gsO
         9WLm0ODXxFQHclwoGz2JKNAeJ/b1hnONmz6nNHFH/t6Dc0gUX6C7blz9QA1NuyZWqYFw
         spZ/RqlVAD4fyQ5eIajKbWdkEC/EUpesN95yRprQoI5ZOgfVBBeHWA6FuITANN+pV1Mk
         2mJLz90hX+MJ2He1mWtIqxbGDsD1HRD4CC/c8RvD9aIAPKGScUyY7qMVoJ+OT40Rkhwz
         Dyag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760479465; x=1761084265;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l6XDsENWGoamE2lQfBoeAOTQv2/NbQK1cLV8RQTx+rU=;
        b=g8Il42Xcxrlt/wgTrU1k823z3Kg4VkQvc2Cj+MP1kCgetBIeKgkUyUVKb+RqmZMDzD
         EQ6hcnZ0f2sCXaDw3TIbKvi2/vfssbKADo8rN3UvaAdHIIBnVuGznzlFiddZ3EQtHwK4
         Vw8VBtRcfDMvMBYtQ38ZjG4/0acCvCKmqcnYXyD1b5Lwa4hOWBU9WsMYx5FSFONsYj1I
         Aq0rrf9LJy6NhlmatP5Ls/wmnbR/Q0tRK67hsOJhiL/bh3PWcpZOUBUdKvBE5GKVx960
         homxpCJPJze+KiZjTldQuO29FGq/PX0wJIP6oGQL6TgR4LTLu1Z+oUOOskdDTTxVIg6t
         pYuw==
X-Forwarded-Encrypted: i=1; AJvYcCVDcPXAohJ9r+oCN4uEWly8Lk+PW2ctPhB8XFtP8j6OHUqxE2n8jlY9QUV6SFg1mGi7qCIFVdx9UIL1fFsX@vger.kernel.org
X-Gm-Message-State: AOJu0YzGw+YHQE8ZwNUohDx4Iu0kx/63+KlBZiC4ltNV+g+kNntsIPm4
	jWqXuKIGNQAJtwfwvE3cnIctdQKykdbDLaWukqmubhmgL436713Bslkl
X-Gm-Gg: ASbGncsHbMy8p//I/WnDnl7VM5TRgYwsq3o6ihMYBjyfWzJAUbhW5PJw3QJN1rPZRBx
	CaFdrgOsLQoQfk2uz/sFfy+pAxEjeyeop1lbggA3hx3oBH98PyfFdys7In6RaoNXWhv1OSNZhf/
	UjcVRtDJaylH2IWU5EPRD/3r9Kcgus7GsIM7FcJtTDQBqrfjmOMDDzyPW9hTSzslTxyI80htixS
	FVIQExHYOkREAMM4rtMrb7v9+NhcWjUpr7ihOytWydi82fkTIe5F+S0lS/gwWuE4KLnhpyBcgvI
	vvmDc36AKYLxE/Yw1zliuL79+Sa37PD7BiOvGJDEiZUXrfFx5uu2AcchQKHTGe4b+pMWdmssSQZ
	QvTgzzPIJV7+hFxmq7bAtkznXHiTvSDVLQ7Y8FpKlvJwllO5M16EOQsoMlbzYdsO2sYdZ5wjh59
	hO4mstYd64ZVdBmhaoeIiKYj8l
X-Google-Smtp-Source: AGHT+IHUB3rz/slBsn1LJeEC9+FO5BtqHcvv9o2+l1YGXAcHXI2KItjdeh1X4Zw/JN1lCdNJMeKK5A==
X-Received: by 2002:a17:90b:1b41:b0:32e:8c14:5cd2 with SMTP id 98e67ed59e1d1-33b513d0b37mr31894521a91.28.1760479464543;
        Tue, 14 Oct 2025 15:04:24 -0700 (PDT)
Received: from [192.168.50.102] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b678df7e1d1sm13042068a12.40.2025.10.14.15.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 15:04:24 -0700 (PDT)
Message-ID: <e890fbd0-7b05-47d2-a444-f61409e4bbf5@gmail.com>
Date: Wed, 15 Oct 2025 06:04:18 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] ovl: brtfs' temp_fsid doesn't work with ovl
 index=on
Content-Language: en-GB
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: kernel-dev@igalia.com, Miklos Szeredi <miklos@szeredi.hu>,
 Amir Goldstein <amir73il@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, "Guilherme G . Piccoli"
 <gpiccoli@igalia.com>
References: <20251014015707.129013-1-andrealmeid@igalia.com>
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20251014015707.129013-1-andrealmeid@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14-Oct-25 9:57 AM, AndrÃ© Almeida wrote:
> Hi everyone,
> 
> When using overlayfs with the mount option index=on, the first time a directory is
> used as upper dir, overlayfs stores in a xattr "overlay.origin" the UUID of the
> filesystem being used in the layers. If the upper dir is reused, overlayfs
> refuses to mount for a different filesystem, by comparing the UUID with what's
> stored at overlay.origin, and it fails with "failed to verify upper root origin"
> on dmesg. Remounting with the very same fs is supported and works fine.
> 
> However, btrfs mounts may have volatiles UUIDs. When mounting the exact same
> disk image with btrfs, a random UUID is assigned for the following disks each
> time they are mounted, stored at temp_fsid and used across the kernel as the
> disk UUID. `btrfs filesystem show` presents that. Calling statfs() however shows
> the original (and duplicated) UUID for all disks.
> 
> This feature doesn't work well with overlayfs with index=on, as when the image
> is mounted a second time, will get a different UUID and ovl will refuse to
> mount, breaking the user expectation that using the same image should work. A
> small script can be find in the end of this cover letter that illustrates this.
> 
>  From this, I can think of some options:
> 
> - Use statfs() internally to always get the fsid, that is persistent. The patch
> here illustrates that approach, but doesn't fully implement it.
> - Create a new sb op, called get_uuid() so the filesystem returns what's
> appropriated.
> - Have a workaround in ovl for btrfs.
> - Document this as unsupported, and userland needs to erase overlay.origin each
> time it wants to remount.
> - If ovl detects that temp_fsid and index are being used at the same time,
> refuses to mount.
> 
> I'm not sure which one would be better here, so I would like to hear some ideas
> on this.
> 
> Thanks!
> 	André
> 
> ---
> 
> To reproduce:
> 
> mkdir -p dir1 dir2
> 
> fallocate -l 300m ./disk1.img
> mkfs.btrfs -q -f ./disk1.img
> 
> # cloning the disks
> cp disk1.img disk2.img
> sudo mount -o loop ./disk1.img dir1
> sudo mount -o loop ./disk2.img dir2
> 
> mkdir -p dir2/lower aux/upper aux/work
> 
> # this works
> sudo mount -t overlay -o lowerdir=dir2/lower,upperdir=aux/upper,workdir=aux/work,userxattr none dir2/lower
> 
> sudo umount dir2/lower
> sudo umount dir2
> 
> sudo mount -o loop ./disk2.img dir2

At this point, Btrfs assigns a new temporary FSID, but without it,
the test case fails.

Temp FSID support only came in with kernel v6.7, so wondering,
how is this test supposed to work on older kernels?

Thanks, Anand


> 
> # this doesn't works
> sudo mount -t overlay -o lowerdir=dir2/lower,upperdir=aux/upper,workdir=aux/work,userxattr none dir2/lower
> 
> André Almeida (1):
>    ovl: Use fsid as unique identifier for trusted origin
> 
>   fs/overlayfs/copy_up.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 

