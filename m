Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5892A17A31E
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 01:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778895300; cv=pass; b=KTuUuj57l3lxzRNQV6cvdKVMqjE5vQ8ZIb3SbqcHvlRidnzPqkFrvTv/BLH3w1KNDbzu2k8PgGA1elkGwN0jNoecJQtOS+dUQtYQ8Q5QOO8j/1+7rq0oqu1i/BcPao9ukTtWQRod5LWXfNhLW8yglKaxo3pWN5e/APY2AZbrayk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778895300; c=relaxed/simple;
	bh=F7km6eChtSyp2Y5Xq3EsA33guP/82gQchf6F9hXMOsA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tcm2XVoEtrG+WMiErWP3GDrWPuMlJ/HerUosAaX/TE29KxHCqqaXYGnrA8tgpqi7CxRZs+vfzlcUX7LVlq5C9OEWxST9whpfmtXlehQug/h3zfzuvT7lKDncC6BomvpxBRPYXfpuEFK9cx84V4JCqtPafBBCIS/PD/nh4fU9dio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDJCI5Nd; arc=pass smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDJCI5Nd"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-449d6c68ed8so304128f8f.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 18:34:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778895298; cv=none;
        d=google.com; s=arc-20240605;
        b=O7oROVmOM1mn1cWbsIY9k7inc9o3icJNkSwNW/pyuEq8Ruu+tuUwyCjP0K5fJUa2fF
         7nGRPJ+QKqqqA0aLT4h4GgDfGQnpX83FQfer7+VU1DlBkyeudyXw/l1C9fYn0kEeXN7A
         yKyqxYjt+P2ws+jR7F0i0Wx89FDrP5vq97qhNOrTMcYLRh+mblw8NTSP0uy+rLhXlsh3
         u6YwkHS1feE5F7OQE+KocWkmYAoFdkxSlPYLk0VUQwgHAWEbwPtfcEqYUhe6qfdaTQEF
         n4IHu7cx7UozqZC+bfp1iicl3972BaonrY4B8m/W7iXH9NasPE+BfQOUiFAxaNK75ZdG
         MuTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JstUOIj0O2wXj8D7NvhCFhebmhsNBhGSCHfWtO/MKF0=;
        fh=Dh5OXjkVMR0etyALB48ld1cq1nVmYs/y58TCZbFykW4=;
        b=CRntYMealIc4juPfGQiJM8Llrdet4CLEbfZ8WkoC+JZf/ZUVJE4rXIxBK14xleNHR9
         cRNR52TJeezuT3aDwZdnlRbtGZrqrl5mFQEs7DyRksEeZKaHagy7NHFhCK2thHfPdOVK
         jX5rew3XSIAj+roQQaxCPAgwRT4BH16nqGE5dd57D6Yn5Egd8uYKD/LRrEBx2D5AvL+n
         Vb1myDlTDw3Im0InyPND/Zz/cQ9JBI9kkphZo4sNWJ7au/kdcnbkZxOmAWRbjkWmpztM
         HCy6bApilCd4p4paok4Uqjal6D2wkJu1XyGiWz7D97adxXq12afGgH8J6qqyVS3gTng4
         Pcjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778895298; x=1779500098; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JstUOIj0O2wXj8D7NvhCFhebmhsNBhGSCHfWtO/MKF0=;
        b=PDJCI5Nd7ErR7p+aErdrMXCLi1dhyKnvTxXccl1j73aojglbYpPSiSMq9mwiK1wwpt
         Xvhqi91qDL84FWu/Y6mpFkSUdXzRZVUTD33tps+ggsZcwY7G9xr9cd0B3UBzjOBkSJun
         4MHPJngNSHnHyYo5z/mPnDBjl9W6IdMahwBwAwMn+bg1wAY3yabJRr5uWbaunYO6hAfP
         qZn+lncngEyw5Mw/vQCUgVa1aC8/r0qTp7Ww8pYXVFSZ0QF0KbxFRhEDoVWoH8PWGAUx
         2CUauyBZSZo912uX62377QiZOMOLPHur4xxk+qarDFfUNTZEi2peDW2yGhZebU2lq8qt
         ASnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778895298; x=1779500098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JstUOIj0O2wXj8D7NvhCFhebmhsNBhGSCHfWtO/MKF0=;
        b=SSqbPWv94bbw0uyPnwcsjMKCuPLvdD7MqJ0H6X3KAZvDBwgyH56c/Y1sew9nUo/VDB
         GvmnN1eGrDF6DROqP0xTYgP7QVqVD4kJ7gtDNFwqn0nLSTcofue7yvTLIyXUNKodWlTq
         7UgPhLmfo6oq2d3T+E8Pho9bpBi8jy3UU56gKsX8VSD/Ciy9lEhmhmyq0BrG8/BG1Meq
         +6iyrDtn/YR5XqKg9adj/JH+QWZJnileanB+YDnozi3s5bFoYeIW2VVhJJSSZaxXC7B1
         t8lIokng1fW7aLmRHFgy6duzONn5QEIhhtX4HQHNw1mvjoBp+LiCZCzSFKbQM3DWJ6Cj
         mDpA==
X-Forwarded-Encrypted: i=1; AFNElJ+iM1kEhT+YzmGRiGemDoXXvrQ1Yr7i0FvJ9vjKHK39Vq8gkUK60woKIzfz9VrXNHPSsLGKUoIeBTqKHeYa@vger.kernel.org
X-Gm-Message-State: AOJu0YywTicWcvEeFXJDP2PvNkBKHQj6YwNHwt+mu8UVVn3yDjqBs5A+
	gKrcETuA4ZklrWx+DApprcP19j+15SVYex4K1NlxJ+MO6cDSzAJ3Jiojeoe6jjFlajpOesQPRyY
	nBoVYzkvn8M5XI+OQ6dLx+7YEeRxZDto=
X-Gm-Gg: Acq92OF3zkwbMAl+ykBLUgsIm9i1QOAFXM7VUWb3NbXxEJLcZJ260KiIzuzIl64Rchj
	F/llDqe/2D8Yjj1z45KqD5Z6CwRhXuWNa94MPbfY+PTZbWJEdXEDvy8Re8YR5h+4iX3IKQFLHaK
	rxh0hosGWWRXHrYJ30EkAK0kc/MAQEVuCzCXLxqdNQhAeXZe5DLGJAHIiuVx+om/8hJfYNxyb4c
	SBWXy8SgunTQI432XDmVPYx++O/iiQtKC8On1qyWVgBPqpkvMVZurMoENnQN2MOk/4rHEEhcDwV
	1CMhXoQCvb57I9nDM54qNOzv4Yk=
X-Received: by 2002:a05:6000:2f83:b0:43b:5097:6f62 with SMTP id
 ffacd0b85a97d-45e5c5952d5mr8537536f8f.36.1778895297654; Fri, 15 May 2026
 18:34:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com> <20260516004004.1455526-3-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-3-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 15 May 2026 18:34:44 -0700
X-Gm-Features: AVHnY4ILtCQ_AOG5DYsskxeKqoMXIE_zQsn_MfmhD8zGLD3sEbQFfZKyv7t9T4E
Message-ID: <CAJnrk1YUjqd+j1yLXuO0M07ueCUYNC0NqgwmQSm3OiY3hnhgZQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/21] fuse: prepare for passthrough of inode operations
To: amir73il@gmail.com, miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 5:52=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> From: Amir Goldstein <amir73il@gmail.com>
>
> So far, fuse passthrough was implemented for read/write/splice/mmap
> operations for regular files opened with FOPEN_PASSTHROUGH.
>
> A backing file is attached to a fuse inode, but only for as long as
> there are FOPEN_PASSTHROUGH files opened on this inode.
>
> We would like to attach a backing file to fuse inode also without an
> open file to allow passthrough of some inode operations.
>
> Add field ops_mask to the input argument of FUSE_DEV_IOC_BACKING_OPEN
> ioctl to declare the operations that would passthrough to the backing
> file once it has been attached to the fuse inode on lookup.
>
> Setting the FUSE_READ/FUSE_WRITE operations in the ops_mask is not
> required because those operations are implied by FOPEN_PASSTHROUGH.
>
> When setting operations other than FUSE_READ/FUSE_WRITE in ops_mask,
> non-regular backing files are allowed, so we need to verify when
> attaching a backing file to a fuse inode, that their file types match.
>
> For simplification of inode attribute caching, for now, require a
> filesystem with FUSE_PASSTHROUGH_INO (one-to-one mapping from fuse inode
> to backing inode) for setting up passthrough of any inode operations.
> We may consider relaxing this requirement for some inode operations
> in the future.
>
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/fuse/backing.c         | 13 ++++++++++---
>  fs/fuse/fuse_i.h          | 30 ++++++++++++++++++++++++++++++
>  fs/fuse/iomode.c          | 16 ++++++++++++++++
>  include/uapi/linux/fuse.h |  9 ++++++++-
>  4 files changed, 64 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 4be9ccc5b3ff..0f1e1c1ec367 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -243,6 +243,7 @@
>
> +#define FUSE_PASSTHROUGH_OP(op)        (1ULL << ((op) - 1))
> +
> +/* op bits for fuse_backing_map ops_mask */
> +#define FUSE_PASSTHROUGH_OP_READ       FUSE_PASSTHROUGH_OP(FUSE_READ)
> +#define FUSE_PASSTHROUGH_OP_WRITE      FUSE_PASSTHROUGH_OP(FUSE_WRITE)

Do you think we should couple the passthrough op code to the fuse
opcode so closely, instead of defining the passthrough ops separately,
eg doing something like this?:

#define FUSE_PASSTHROUGH_READ         (1 << 0)
#define FUSE_PASSTHROUGH_WRITE       (1 << 1)

In the (far) future when some more advanced passthrough features get
added (eg full subtree passthrough), it seems like we'd want to add a
passthrough op for that, but that wouldn't map to a fuse op. I think
there are also some fuse ops we might skip defining as passthrough ops
but are implicitly passed through (eg FUSE_STATX which is covered by
FUSE_GETATTR), so it seems more intuitive to define the passthrough
ops as describing capabilities rather than implying that it describes
what specific opcodes get passed through?

Thanks,
Joanne
