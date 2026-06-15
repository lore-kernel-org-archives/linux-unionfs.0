Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21BF2E7374
	for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2026 17:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781546017; cv=pass; b=N/bVoeS1JINnLo8uPRe3ozs7tjjU69IIEkPFsKurVJb00Egom+G8+XRtmhYadyq7fi6SI06uE3vLN9xGWtKnHBDu0Dp6gN9WJhunuPvUOIezA85ZFz3Hd5g7uqtSduDuQV/fLZrLAqHZ6w7mBFMguefOmAbliYQ1j4dVugnRJIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781546017; c=relaxed/simple;
	bh=0G/yNPJ/1m7tr38GWnPb4fAzqTIlXjcfwr1M3ZYOz30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ruvODCLsKv/O7I9xaO7JwnFpoonU7EZ2S+OKQkUdr4E5/H+viF+wfluThsHh5bnbDcxFWlUdMs9tQQMGU7XuowOUhfptja8eQjKpEvrsbPskkiKoX6/pDOPkSvZOZ/QLimnTYhVDHCcbchcz7PpGew5ocWSyZVzhqNz+NI5DBmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cNvqOivS; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cNvqOivS"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bec3ffb95dbso536509366b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2026 10:53:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781546014; cv=none;
        d=google.com; s=arc-20240605;
        b=dlyAJ1ebvTKSkWYHYY19Lx2cySsFdD7CdeVQYjyTxbnd5ZpiyX/c920j8d+b+i1XLd
         XD/8b2tulPWYvT1JkK6w5CBWN9SlsGCraY+/KB0yeVvlb183SEGL15dQdrlpJE0ZGTrt
         hYFXsdU87moY2UJ6pI7ZH/RQq1WV9yA0d6GbiBxpQ7QLRCcc+8UZdN+UZ205FSnRcbkd
         ksykZ0kDNt9PjYG+gIIiHq4BeADC4PUgOiUo92eMpaVvqldp9tB45bdXWIya4YD/YRo8
         EEj7iaiTFiKBaHssHFQNPKZmSyUq3YijLZ29wFROWQggieB/nCEALFpFsYRq3nvAple9
         NmaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FvfUWdyRuyxa3u2z5Qy4nMVVFAzQcvrFkMSMc+Z8Zvo=;
        fh=z0FaHLewK+9pF0LJjIwuxXaLZ2qMmx4jsR+SNmVCr2s=;
        b=g9ZGs6iuKPgBES+VH6xkCLiEUAYhAC70K8g4dUerLjkUMphXbi4MkJq7sPwhsJbs4M
         RfuiOPc9noJiBk0B3ZgOaDcX/bVK6ua/RWBugnF8FBwBxHuJYLzh027Xb+KCFbXu4Gjh
         cbzRCqKj1NH5HNwCfuKr2kqgdnxLQ4wHH1W2gkzcPdsLJ+PqFDcVovMQqlanuEWV98R2
         FTk8FC3NgRm81DelmupFQ4yVGdz11TODV5KWZeFcDbtd0zigpgQWNxh3qEcy8WlTlNeW
         21r77GX/yj3Vx98q4ba6mp6SIknkBc0qR+MoGFx8C03g+4V69SbhVJbzEraATIRpYk+B
         s5nw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781546014; x=1782150814; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FvfUWdyRuyxa3u2z5Qy4nMVVFAzQcvrFkMSMc+Z8Zvo=;
        b=cNvqOivSTswmk0Fl+03k9zzGsI2y5E2HVNdj6LZ9AVD4UFSq6LA1gBj18rg3vLBeyl
         bRoY7miW/U+O3znHcWMYJLoNwAy6NGUitHRIn4+t/G6m7pN6fpnr1Tk6MLXRDQQZzUFF
         QB+xirZfLJ/SZkM9v3SqS4kDXoG+EO7cnIl56iIo1UIAqn34zYim7FlJiOW+5vhrVuBN
         VaKaip1O+DeheXjCXyowzunSOgj7DhqkY5EB+ewMnMJAGEhPG3ANPSpnRS+aM/ljvrR2
         FD+d7MM9cqfLftIAWsbXqW7SJ+/6IcHxKss7P0rd6mM9a+VF+lp7hCt1X2XykJzEYZiF
         pvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781546014; x=1782150814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FvfUWdyRuyxa3u2z5Qy4nMVVFAzQcvrFkMSMc+Z8Zvo=;
        b=bTQ8u82yVsw+XZK/ch7wutJJt4OYdugmB6+i1L5SG+b+yaX68s5s8yL1RWNftZrNh+
         TmPi2zccoe1saeRkd/mF+WqxjWyOQqoDjCYx1iSzQvC5cYexZq4/XiuSYh8mExWIV28W
         J+qdr5eFUwdrjDSaK/IsIKCX6TtgN6a48ri+TtDWRsV4n0GYYyRzRL8Cw1S5C8FP/uNi
         MoMwSUoVll8Rk2LXJck7ZDdzoe1FAu0TtL4kQi+Mx7k2kuaDahGR2KVOy5VGuWLt7NxP
         dhfXBfhGcs7bjDeNZH8fq0EjsML8EyP1ltci8tM9b6pOVk2NgEk9L1YB4PvDB6oh4eKQ
         41Jg==
X-Forwarded-Encrypted: i=1; AFNElJ/XheoiBTmCf5myiL1Q0Pldl/qLtZ1vr8EhlZKLBHysADMGX1fRhK1mn5O3XgzTk9u09BLwGq0XKzFEejFE@vger.kernel.org
X-Gm-Message-State: AOJu0YxVqf5oCT5ChkUqJkJUpMu1AhhkBE6q+MEq+UlL/x5gP58tVQhp
	Qrx8+6bx1fJdUQPKrJ4/89ZVjZYevOwsX11uatSmmt0F/Aa2b8Ined/CTuCPW/ZsZAw30Rsk+WB
	ndpoHMOMOaR6RWaONtDjOOAiMZjAK3ijYvBcjIfc=
X-Gm-Gg: Acq92OGZBcoOtLEQxn+ldaVAR9UIJ+dIp+8Z5awf7iyND/+DjqEc+QPugNKpKsFFil+
	HlvCa+YfZLmRFJ8pl7NeWu+MSRMB4ASp5EjCAnK46F+cwod2jHyUgtR22TakeCUtvEsf3JEM3vo
	Kn8E1vFuWMjJW2aOmHvCsKKF1XEY2xYYirdn6SN83Rzg/W//211PdqqSn7hfQDVLNRHgdc7fzia
	jwZY+W9onMzZrtbI6iqzlsJvTfN5DN8UlGzZ9VVRjKqrO3MZ3FIJ8LnniJmIB2goH+oYP92E384
	Vzl5SIi+Aw8we5YeJ5La+mGe0OyQ71p3Sye623IBzpzX65IEy2pJ
X-Received: by 2002:a17:907:d005:b0:bfe:ed16:283e with SMTP id
 a640c23a62f3a-bfeed16390amr666725066b.50.1781546013838; Mon, 15 Jun 2026
 10:53:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org> <20260615-overlay-idmapped-vfstest-v1-1-c6b3b2228092@kernel.org>
In-Reply-To: <20260615-overlay-idmapped-vfstest-v1-1-c6b3b2228092@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 15 Jun 2026 19:53:22 +0200
X-Gm-Features: AVVi8Ced8cu6caxj6v_YSBuVL33Q__2az4mLoJJiSj08lOxoClHvwU7me3e_C9I
Message-ID: <CAOQ4uxiG22xqx_C+539hbH5v4NHdALWBn9khpomtVxvQ0fcfFg@mail.gmail.com>
Subject: Re: [PATCH 1/2] src/vfs: probe O_TMPFILE support on the base mount in
 the idmapped tests
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Zorro Lang <zlang@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 5:33=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> openat_tmpfile_supported() in the idmapped mount tests probes O_TMPFILE
> on the idmapped mount (open_tree_fd) as the test's fsuid -- but that
> fsuid is not mapped by the idmapped mount under test, so it really asks
> "can this unmapped caller create a tmpfile through this idmap?" instead
> of "does the filesystem support O_TMPFILE?".
>
> On overlayfs this is a false negative: the backing tmpfile ends up owned
> by an unmapped id, overlayfs opens it with O_NOATIME and may_open()
> returns -EPERM, so the tmpfile sub-tests are wrongly skipped.
>
> O_TMPFILE support is a property of the filesystem, not of the idmapped
> mount or the caller's mapping. Probe info->t_dir1_fd, the base mount
> that the caller owns, exactly as the non-idmapped setgid tests already
> do. The probe then succeeds on every filesystem and the tmpfile
> sub-tests run as the mapped fsuid.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  src/vfs/idmapped-mounts.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/src/vfs/idmapped-mounts.c b/src/vfs/idmapped-mounts.c
> index ed9992f9..8f8441c9 100644
> --- a/src/vfs/idmapped-mounts.c
> +++ b/src/vfs/idmapped-mounts.c
> @@ -3838,7 +3838,7 @@ int tcore_setgid_create_idmapped(const struct vfste=
st_info *info)
>                 goto out;
>         }
>
> -       supported =3D openat_tmpfile_supported(open_tree_fd);
> +       supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>
>         pid =3D fork();
>         if (pid < 0) {
> @@ -4014,7 +4014,7 @@ int tcore_setgid_create_idmapped_in_userns(const st=
ruct vfstest_info *info)
>                 goto out;
>         }
>
> -       supported =3D openat_tmpfile_supported(open_tree_fd);
> +       supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>
>         pid =3D fork();
>         if (pid < 0) {
> @@ -7733,7 +7733,7 @@ static int setgid_create_umask_idmapped(const struc=
t vfstest_info *info)
>                 goto out;
>         }
>
> -       supported =3D openat_tmpfile_supported(open_tree_fd);
> +       supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>
>         pid =3D fork();
>         if (pid < 0) {
> @@ -7947,7 +7947,7 @@ static int setgid_create_umask_idmapped_in_userns(c=
onst struct vfstest_info *inf
>                 goto out;
>         }
>
> -       supported =3D openat_tmpfile_supported(open_tree_fd);
> +       supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>
>         /*
>          * Below we verify that setgid inheritance for a newly created fi=
le or
> @@ -8181,7 +8181,7 @@ static int setgid_create_acl_idmapped(const struct =
vfstest_info *info)
>                 goto out;
>         }
>
> -       supported =3D openat_tmpfile_supported(open_tree_fd);
> +       supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>
>         pid =3D fork();
>         if (pid < 0) {
> @@ -8536,7 +8536,7 @@ static int setgid_create_acl_idmapped_in_userns(con=
st struct vfstest_info *info)
>                 goto out;
>         }
>
> -       supported =3D openat_tmpfile_supported(open_tree_fd);
> +       supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>
>         /*
>          * Below we verify that setgid inheritance for a newly created fi=
le or
>
> --
> 2.47.3
>
