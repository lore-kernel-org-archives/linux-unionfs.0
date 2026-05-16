Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806F930E0C0
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 17:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778952319; cv=pass; b=OBTXk8PKXKISdLJqjXWknpGDUB3iZ71kC1/9ffvvNeYEq1MJebLz8mIdVWgDrwubpcb8ClGj0d+NPPdMEJcgbuy6HLdJc/pqmjyKI5rKrnS0JFN07Uca5nplm1jJzxL2wOruyPoeQ5sHbpn/4Yb4wkjWEPhAi4ohNpezdADi7JU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778952319; c=relaxed/simple;
	bh=TRzKnwOpTkmGDP54Ru6Sc1PGEgP5u8OUH3r0WniHtSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cCCDlJr9LN3Fe6o0aFGe0WSmrCi+1yEIQm2MOJIGUgrF8Z54JYZgsgOzFO9mPMuNlLrzCziW6dIYMu41R7mc01d7X/MK5c4aEqgF/6B4zuTWbOWwIn5aYDnxerkbpaSd4jWOCHras1Y+ezy+rWu8yHI3jE9WUZ9m0z/D7baLlXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jsTmhGkV; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jsTmhGkV"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bd3eb594960so120744366b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 10:25:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778952317; cv=none;
        d=google.com; s=arc-20240605;
        b=SWEyceaQhzInjX09DneYQjdp6SXRkV6rBbVAnWsSJrJIXpTtkW7nKdvQwYLWgV43mf
         RZfZamBcgqWC/C84V5Dp4Dk2JAoL15ietiLOBy70cgVHH2adfVyjLUS7SVr8P8sL8/Dr
         jbErfSjmHVxVt6gGDVOX2LlyurruHeqJNFuSvUAOK3CQ+kjLKGLecu/lql/9Pq40He0C
         yPuo1ccIMjEF9QTjI+wd5SHTuM98qgEuHoOBuctGOCRo3Ffe8Jin19yAH0IGnOI3q1RK
         vXgsWwZYnImgZQ+Titn4u7nl46LtjtyG2yEfy3WrXP1ZeYKBPFV2yt7KjETuxljAOu9/
         Y0oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WuLZKPjKWL/p0iz8VK3C4t61Vhga9NguF4UvQ9dQHtk=;
        fh=HHa4CdjvgcPt9I2mK40+hKDCvEovykjw9IOILoCRIig=;
        b=FijvxVupeMmj5lck/9gsP/a8Kf9BApi0Fh1O4eH4/Q4mV6ktdANoi/vZxkxaK5UaWi
         CTpP8vijBWxIR5LqNrILUkDZ2upK5h1TyYGowTrDNEU2eMS9FZNro6vy+CekZvmHqmMH
         qVJKpk/7wEt1cYgJ0hByH5pUOy6h8OUTFEvhAAmhaFhtRB2i3ZcWlsvgnHVJoe3PcqYO
         w9iKBXGVmKPR7m5SZAjIMAAMRAybleapY1Jn7/g3OjJ6Fuon3979q0+6BlKg9Bo3/TxA
         XbypxH4Md2dG2ROpgJcyEfSp3HiXrQsSWspmJ8fTkUOcIESlq6pB04wj+XB5q9/P3Bvn
         8/Zg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778952317; x=1779557117; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WuLZKPjKWL/p0iz8VK3C4t61Vhga9NguF4UvQ9dQHtk=;
        b=jsTmhGkVuZFO0FpYGOcJVRB0mClDKkYZypno3Tnyja21r+YPY2OzxzuRc/osGII38i
         gsqaGRQdDCcR5bM3StMFrFsA93JW00qo8842LK3QpR5jDmBlk2axMPEPdC0D3UbWHWGj
         YKRxzVLiVEPxdK91pY/dk46qOjCAIvqtUWNWWTaII4YrZBr4wdDm7vfLSp0AJ4EHIRP1
         HqoCwyZjWJ1pcABUDZTD/pKpHamh8uL0GWSmcl4o7Kdov3GH1QwbxZXgKsc0LDqHZ36I
         P1VXSp0LcTXWk3bjNaj2DUUp0hguKexhLohlm/j7K/dyqkQ+HaINOfMCFp2z27h84bZ4
         VDwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778952317; x=1779557117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WuLZKPjKWL/p0iz8VK3C4t61Vhga9NguF4UvQ9dQHtk=;
        b=nNUiUjaIEslNprbuReTcHvTbGU+kELKonBKdPZqAw0lOFXZP9E/ItZstcglJWeIJ/3
         07LvM8DdeZ4j9lImEEFnIlJcLrD9vxJptNeidsd6mWXLWgs8Wq8j0eMJhhmReMWSvb1d
         PnToyDkcNkbHg6lfCYf3UomD6Up8dyjTsckTMGPCsCGbZ/wAxRLl6RHdJjoNmPkFijGC
         zAvvlttzr4ZGlgwJM3t1oIoQrU30kF2JDYiFt0n0xC5DkMxQ6r6WYtKR6sXQXMk3Xyn2
         WsRp/RNaF9VAHaac+m6ZnZc9An42WG+fy8Im/w4+XbKrZsqLxAkIREzvHV6TeMOpBjMg
         3Fkw==
X-Forwarded-Encrypted: i=1; AFNElJ+QG3uVEMgHzberfgkfOZ6ZcAiwUMrz6piM+Xgu3kZO4N57QmwdhP0nMXB6KRNugJ/vEBONvcbJqCXMUzQZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3boTEIWrV1b/dHP/19MPKJ+7fWwjiykp+gKToXtE/nL2FZLZq
	2A5PSFZJcFr2CqQEoiRgm2Jb4cJPCWzeGF1ePYkJNf34AtNxvzJN15qbnp34PB2CwUGU4JsoRu+
	LpPizc69J6aDIETw+Kh2s74bApH+vML0=
X-Gm-Gg: Acq92OHpGjo+uK0mTeb9XGYorzZIizLiUnc29+HHt9FdLSnD2zaVg3ajmgvyVihaii2
	2hGXMVtzPTCjxQeD7ad5nr2xGd2lw/d9fo00/ORtDW4ZfssZBVn9FOfsUR9VXCnldAnAgvi3kSs
	XKz/VcaBKST0dqe0gQkggbq87bQNwnKAxxYdcqWIiTMvsP+twwkyvtBnS4pN4BqKz+83ulnqBek
	CCu4tBfvmXAFUeqLrvRz96F7nUxpvHmVeE/I7xgJkTfyWiQsLrbcdH2kBedArc7w0iKKbeD5y8f
	xr90DJL47/MouK3SwQPLTpx4SEDu7ZwiTfNI2dB+popOBinLkwXJ
X-Received: by 2002:a17:907:72d6:b0:bc7:73f8:9f4c with SMTP id
 a640c23a62f3a-bd5177d53admr451698466b.8.1778952316820; Sat, 16 May 2026
 10:25:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com> <20260516004004.1455526-13-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-13-joannelkoong@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 May 2026 19:25:05 +0200
X-Gm-Features: AVHnY4KPI_sg-23dgq26_rEOk4j-ANoCa8Utj1hjtkLFAnKF26aaX5m2wSLyraM
Message-ID: <CAOQ4uxjMPPp-R37yKoOs1kGUdAOmnp3keVWvfuxi1r8jrxAcTA@mail.gmail.com>
Subject: Re: [PATCH v2 12/21] fuse: add struct fuse_entry2_out and helpers for
 extended entry replies
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 2:52=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Add struct fuse_entry2_out, which is a new extended entry reply struct
> that carries a backing_id and statx attributes. This will be necessary
> for setting fuse passthrough on inodes.
>
> Add helpers that subsequent commits will use to process fuse_entry2_out
> for passthrough support for lookup, revalidate, and create.
> fuse_statx_to_attr() is also moved to earlier in the file to avoid
> forward declaring.
>

I think you had a discussion with Miklos about whether
it makes sense to do a compound response for LOOKUP+STATX.
I don't remember the conclusion, but if this can save us all the
if (use_entry2) { } else {} all over the code, then I think it is worth it.

Can you give me the bottom line from your discussion or was there
no conclusion reached?

If we do that, where do we return backing_id?
Could make use of the reserved[] fields in fuse_statx_out.

I happen to have a test patch at the tip of my fuse-backing-inode-wip
branch:
6e296625eafd6 fuse: support setting backing inode passthrough on getattr

It's not using the statx response, and it was just done for testing,
but in theory,
if a server wants to  change an inode from non-passthrough to
yes-passthrough mid lifetime
doing this on attribute cache expiry may make more sense than on entry
timeout expiry, because backing_id is an attribute of the inode not the den=
try.

Not sure if this is making any sense.

Thanks,
Amir.
