Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794324844;
	b=CqVXmSaRJ2kUQzGOeNsQaKUJRdU5/d+xRSJS77O6gIuIDLhmUTbsPE1Mhd2qW1Z8ivAs
	 rk6mkSbnVfqU33nPIiGX4qZwDAIDGzxnOQvVn8mrY6bFj0B7yl9j0GCwHuQUo0rwLWNTe
	 +bRACTPDLaiWCWDvjt64P2YRAc4S5617v7zmrCTv6WX0Ld/sV6fEXQXOZVgzjWEVCV8TC
	 SgB82z8c1MNAxxFXTUxtOjdLi/sGPsbCDsS8njxNovclvw8oaK9qzXbAXPGvyzsz771O9
	 y0F5VFkZlXkRBP2hcqimgj/5/PtncGgweT/F6A+wD6TO4okkP1hjB7IpTtE1/fSUBaQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794324844;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zlp+b6aXAaDg8cECS2ZSmA7rI3yE9bTLJjk2dHCmIwE=;
	b=HEb1boWfiFfjWbpw8EQQY5qlBU4CEWauaFWjiU0K9sESi05IM8+KKifwOyteHHEgYCR3
	 CfmJ8cZfbNpFk4XFC6q+jp1wYR4M+8pNmRkEmIMhOUKXXWuocy6+xL/9msmUZd4Ot3Kpa
	 6jWGvPXDTlOJW+hjONkNiz2HrNllgkXOa+qcNnWcbhanXFgm33uVMcAWBsT+pPo5hsSq5
	 GRo8sXNIiE3Xv1PdC2zMUwkiylEA+zMVHz9Y/9cTZz93xbuEAmTKFXOdX71XqCWbqljJD
	 Iv2vJtra1ves4TRPvUk0ON4oIryNExY5eqJgnk6s67ak9ofDZ1FThTp93nf3K3qn5Cg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fLDtc0yG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3066606A32D
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 15:34:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3066606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fLDtc0yG
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b7221c0f2cso1248791a12.3
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 07:34:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794324842; cv=none;
        d=google.com; s=arc-20260327;
        b=C1PHDMpuVTZweQjDkB45awzG8ogEhrQvc8OhqCdl7HiiZZYFmjgHgpdq8OWtt8auFy
         Dn72z8FvENHmRvJ0bB7oSthhpF4gqmp1h1qzT93xukBPPeb3Bq4bZB4Q5MEfeupa8o6y
         /FVUYynSrIJTtTbkGfrj+utMtfaKh+4IhBmfoeMQ2qD6MCRPDCaHNQmegBzFVHFrovux
         aWma/pamw1e+yz0xYeEO2AkzRtA9UcTErX/s4uGNhtOeAar7vUMAMl3xnjUX+fzk6s8E
         MbaCJUTj8zfBS0U/7BTwWIe3GnTnu3x7HQ/MhHqzk6QyjDd4GNCCXCO6ll8R9MtgzTFB
         tn+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zlp+b6aXAaDg8cECS2ZSmA7rI3yE9bTLJjk2dHCmIwE=;
        fh=w1Sz+JN+NvP7CHGVdsVffdg22Ra0sIYIAHpFNXcWMVw=;
        b=EO6fG6hccI0AifDWFKnFEjLShTEGGQZeC9VAjV99SnKP0pEfHG646uIfk9f28R6glP
         JeTd46GJKfvHAk2C9jWB2In4iJFm6eUfIbhiNbUg8AGEwKlLjblNK+CHCIvYpJ11lj2D
         d8fBHW9GxwtwERF1YwdQ5utOj6RbemejUxsCvcl8+4+fuItdDQITEfBFs2vVfDqhHUHs
         d4yXThXmrZxFnlsXHjVWTjI+HjqIrIFEeN8EALQrdqOAaMC9lCOD9K759fbh75NER5UC
         DPE/v8TyCIh/Kkun5K+u6schVwDigJaXJHB3huRlzA03sUX2obfkkUid3n5Vdao6vkWc
         OWLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794324842; x=1794929642; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zlp+b6aXAaDg8cECS2ZSmA7rI3yE9bTLJjk2dHCmIwE=;
        b=fLDtc0yGAEqSYzB4uSdd1JAwYpi+STBUzN1jhtPeOCecrjURdHE8PiEGPIE10Ae+qv
         OfDN4d7rYaxL1EpxkejgK1Yy954mhaji1CtDg9AZAaVt+GFGcc8OPa8llzyJjIhtz1oY
         WrwmJEyHySGLS0HHYR2KnOMWeQsHXDuBy7ZVXDs8MiFO642DgYFIAnN1ARElewaKSJSB
         NHUOhEcbVavO1ADlfxcKihR7VwygfBBHr6HNKcbHDj5rKFDxUP8QHiQ1Sw8wBxvYkTEz
         aBYCsBtAD+Qrk20zJFGONPUc5Ixh6JwanXx1y6+dKCXkjpl8LhZEabpPde/YeIceynsY
         YNwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794324842; x=1794929642;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zlp+b6aXAaDg8cECS2ZSmA7rI3yE9bTLJjk2dHCmIwE=;
        b=l13u7f8qxxIxChfJmCyR3b8L6wXbUvVw5GlZrRUUwKqBS6REestvWAHGwHt9KAOBWy
         cdniVK5fsQda3r+3+j2FfLr/u7OtxNVNCofgwFn/Ttm2uZ0vNXVej3N/YEzCKL13iNVK
         MP9Cj82bbUQlK2QFg1ywKxO48K4zm8RORaN8/UXhw4scrRFdxX6fW2axXiEDuV090LSb
         xUtKOwfuQS5wm0FcNfMty1noO2F9lwwCMSiN2V2mWfMzzlb3M9Sh1CjKdzOyEBSuNOpQ
         mMx11QrNNUF7KqtR9U8aOVTwC6D5jPIYb7gI41ZG7Cr3H2rBFTnC1EXVIBGGe2LNYNtb
         VTeA==
X-Forwarded-Encrypted: i=1; AL+hErHCJ7iZrkJKX0o8047M88poBLI0zj62u44tKzvLmfnQD//6Kh8uRaXen3sFEwu/MxG6nGkv5ufNV5S4QCKs@vger.kernel.org
X-Gm-Message-State: APuU4Z9q3tQbGXb3AtzGi2jYFcKGkVT+6ExnL/MKHkQ8uKwqKKpmc1jg
	Yx95o5u4nD0U95ew2cWF3Y9gbZVawfQ/q+h2E1tc+qX0h8mF4/2bVqljareVPAC2XNk4gxzA/+x
	Bt564OkaAsKjLadnGFO82g5sEHxsSV+Y=
X-Gm-Gg: AYBFou2KzAsVUHpFr2gfgYsh3o/gkfquXIL+4aQ/zX9LbvEWWTJZMrBR1RNZZ2hxAdu
	NBdPFo3Yfe6Cq/uHgdgbbxdi8vyjr1XF3Op/Kj/iyXlFBvT5u8pW6ImpoW+VlPohdnbQC/Tyo90
	39il7T/GzZrvQP0Wpf9Zwscc+VXnqh8nSWp6U2yaOcvxC0E0MTI72yg7Gu/qk0QzBI8vYrRUd+f
	B9Rdbi/KqXrenyGuD9c8ih3XDbCorr4QFUVhSP3DcOLgWQw02Jr/HrNyoPlrkO0XVJfsj/mNV/a
	81oDGgeo5o0F6SXUAKNs7Cf7OB4x79s0jnlyWEkTRkYvGxEAqW/m7KHJOWLh3Zn0UjFd/T7p9TT
	0lr+GLaP2RTlE4y0lsB0pempXYBVxENSbSCe86/cr8UtbLUOe0eQywXfQvVzV0olgW4tGew==
X-Received: by 2002:aa7:cad8:0:b0:6b5:90b9:e1f4 with SMTP id
 4fb4d7f45d1cf-6b756503732mr1958212a12.15.1794324842006; Tue, 10 Nov 2026
 07:34:02 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110-ovl077-stale-next-v1-1-948a5a434ae2@samsung.com>
In-Reply-To: <20261110-ovl077-stale-next-v1-1-948a5a434ae2@samsung.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Nov 2026 16:33:50 +0100
X-Gm-Features: AclHuK8tKVN6oJ1ZVdLK5C5uF2bVbWTbU-1nULInPwTlctPriCZ11xIRhtV4rRY
Message-ID: <CAOQ4uxgxzee1dqLcYHPWFhkcAxP_WRrJn5DiiL9mB0ZjC83vbQ@mail.gmail.com>
Subject: Re: [PATCH] overlay/077: check a stale entry in an impure dir on any
 hash seed
To: daejun7.park@samsung.com
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Hungyu Lin <dennylin0707@gmail.com>, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 9:04=E2=80=AFAM Daejun Park via B4 Relay
<devnull+daejun7.park.samsung.com@kernel.org> wrote:
>
> From: Daejun Park <daejun7.park@samsung.com>
>
> overlay/077 already fails on a stale entry in an impure upper dir, but
> only when the dir hash order puts the removed file where ext4 keeps it
> between getdents calls. ext4 returns the entry that did not fit in the
> previous buffer first in the next call, even after it was removed.
>
> Add a bare "-" and a bare "=3D" argument to t_dir_offset2. They remove or
> recreate the entry the next getdents call returns first. The old fd may
> list a recreated name with the st_ino of the old or the new file.

That's a very cool improvement for the test util, but I don't want
to fix this behavior in overlayfs so only if ext4 fix is planned would this
test be relevant.

>
> Use both on a new impure dir that only has entries with origin. The
> existing impure dir also has o0, which has no origin. If the next entry
> is o0, its d_ino is the same whether it is stale or not, and the case
> is not checked.
>
> With an ext4 upper, overlay/077 now fails on every hash seed until the
> kernel fix "ovl: skip stale entries in impure dir iteration" is applied.
>
> Link: https://lore.kernel.org/linux-unionfs/CAGEkeHcg06kHshHQ=3D9U6Yrs_wm=
8W9H28o9bcC2Qh3fw3tANbWA@mail.gmail.com/
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> Please hold this patch until the kernel fix is accepted. With this
> change, overlay/077 fails on every ext4 run of a kernel without it.
> The fix is "ovl: skip stale entries in impure dir iteration":
> https://lore.kernel.org/linux-unionfs/20261110-ovl-impure-stale-v1-1-1a4c=
2039e89d@samsung.com/

Sorry but I am not planning to take this fix.

For the problem of spurious test failure, I suggest to relax the expectatio=
n
for the first entry in the buffer or to fix ext4 to avoid emitting the stal=
e
entry.

Thanks,
Amir.

> ---
>  src/t_dir_offset2.c | 126 ++++++++++++++++++++++++++++++++++++++++++++++=
+++---
>  tests/overlay/077   |  25 ++++++++++-
>  2 files changed, 143 insertions(+), 8 deletions(-)
>
> diff --git a/src/t_dir_offset2.c b/src/t_dir_offset2.c
> index 026bc8f3..621255e6 100644
> --- a/src/t_dir_offset2.c
> +++ b/src/t_dir_offset2.c
> @@ -10,6 +10,7 @@
>
>  #include <errno.h>
>  #include <fcntl.h>
> +#include <limits.h>
>  #include <stdio.h>
>  #include <unistd.h>
>  #include <stdint.h>
> @@ -31,13 +32,63 @@ struct linux_dirent64 {
>
>  static uint64_t d_off_history[HISTORY_LEN];
>  static uint64_t d_ino_history[HISTORY_LEN];
> +static char next_name[NAME_MAX + 1];
>
>  void usage()
>  {
>         fprintf(stderr, "usage: t_dir_offset2: <dir> [[bufsize] [-|+]<fil=
ename> [-v]]\n");
> +       fprintf(stderr, "       t_dir_offset2: <dir> bufsize -|=3D [-v]\n=
");
> +       fprintf(stderr, "  a bare - removes, a bare =3D recreates, the en=
try\n"
> +                       "  the next getdents returns\n");
>         exit(EXIT_FAILURE);
>  }
>
> +/*
> + * Find the entry that the next getdents call on fd returns first: read =
one
> + * entry from a second fd at the same offset. ext4 with a hashed dir kee=
ps
> + * the entry that did not fit in the previous buffer and returns it in t=
he
> + * next call even after it was removed, so removing or recreating this
> + * entry gets a stale entry on any hash seed.
> + */
> +static int find_next_entry(const char *dir, int fd)
> +{
> +       char buf[BUF_SIZE];
> +       struct linux_dirent64 *d;
> +       off_t off =3D lseek(fd, 0, SEEK_CUR);
> +       int fd3, nread, bpos;
> +
> +       if (off =3D=3D -1) {
> +               perror("lseek");
> +               return -1;
> +       }
> +       fd3 =3D open(dir, O_RDONLY | O_DIRECTORY);
> +       if (fd3 < 0) {
> +               perror("open");
> +               return -1;
> +       }
> +       if (lseek(fd3, off, SEEK_SET) !=3D off) {
> +               perror("lseek");
> +               close(fd3);
> +               return -1;
> +       }
> +       while ((nread =3D syscall(SYS_getdents64, fd3, buf, sizeof(buf)))=
 > 0) {
> +               for (bpos =3D 0; bpos < nread; bpos +=3D d->d_reclen) {
> +                       d =3D (struct linux_dirent64 *) (buf + bpos);
> +                       if (!strcmp(d->d_name, ".") || !strcmp(d->d_name,=
 ".."))
> +                               continue;
> +                       snprintf(next_name, sizeof(next_name), "%s", d->d=
_name);
> +                       close(fd3);
> +                       return 0;
> +               }
> +       }
> +       if (nread < 0)
> +               perror("getdents");
> +       else
> +               fprintf(stderr, "no entry after the first getdents\n");
> +       close(fd3);
> +       return -1;
> +}
> +
>  int main(int argc, char *argv[])
>  {
>         int fd, fd2 =3D -1;
> @@ -50,7 +101,8 @@ int main(int argc, char *argv[])
>         int retval =3D EXIT_SUCCESS;
>         const char *filename =3D NULL;
>         int exists =3D 0, found =3D 0;
> -       int modify =3D 0, verbose =3D 0;
> +       int modify =3D 0, verbose =3D 0, next =3D 0, recreate =3D 0;
> +       uint64_t old_ino =3D 0;
>
>         if (argc > 2) {
>                 bufsize =3D atoi(argv[2]);
> @@ -61,13 +113,21 @@ int main(int argc, char *argv[])
>
>                 if (argc > 3) {
>                         filename =3D argv[3];
> -                       /* +<filename> creates, -<filename> removes */
> +                       /*
> +                        * +<filename> creates, -<filename> removes, a ba=
re -
> +                        * removes and a bare =3D recreates the entry tha=
t the
> +                        * next getdents returns
> +                        */
>                         if (filename[0] =3D=3D '+')
>                                 modify =3D 1;
>                         else if (filename[0] =3D=3D '-')
>                                 modify =3D -1;
> +                       else if (!strcmp(filename, "=3D"))
> +                               modify =3D recreate =3D 1;
>                         if (modify)
>                                 filename++;
> +                       if ((modify < 0 || recreate) && !filename[0])
> +                               next =3D 1;
>                         if (argc > 4 && !strcmp(argv[4], "-v"))
>                                 verbose =3D 1;
>                 }
> @@ -81,7 +141,7 @@ int main(int argc, char *argv[])
>                 exit(EXIT_FAILURE);
>         }
>
> -       if (filename) {
> +       if (filename && !next) {
>                 exists =3D !fstatat(fd, filename, &st, AT_SYMLINK_NOFOLLO=
W);
>                 if (!exists && errno !=3D ENOENT) {
>                         perror("fstatat");
> @@ -100,8 +160,52 @@ int main(int argc, char *argv[])
>                 if (modify && fd2 < 0 && total =3D=3D 0) {
>                         printf("getdents at offset 0 returned %d bytes\n"=
, nread);
>
> -                       /* create/unlink entry after first getdents */
> -                       if (modify > 0) {
> +                       if (next) {
> +                               if (find_next_entry(argv[1], fd))
> +                                       exit(EXIT_FAILURE);
> +                               filename =3D next_name;
> +                       }
> +
> +                       /* create/unlink/recreate entry after first getde=
nts */
> +                       if (recreate) {
> +                               /*
> +                                * Keep the old inode open so that the ne=
w file
> +                                * cannot get its inode number. The old f=
d may
> +                                * still list the old file with its old s=
t_ino.
> +                                */
> +                               int flags =3D O_PATH | O_NOFOLLOW;
> +                               int ofd =3D openat(fd, filename, flags);
> +                               struct stat ost;
> +                               int nfd;
> +
> +                               if (ofd < 0) {
> +                                       perror("openat");
> +                                       exit(EXIT_FAILURE);
> +                               }
> +                               if (fstat(ofd, &ost) < 0) {
> +                                       perror("fstat");
> +                                       exit(EXIT_FAILURE);
> +                               }
> +                               old_ino =3D ost.st_ino;
> +                               if (unlinkat(fd, filename, 0) < 0) {
> +                                       perror("unlinkat");
> +                                       exit(EXIT_FAILURE);
> +                               }
> +                               nfd =3D openat(fd, filename, O_CREAT | O_=
EXCL,
> +                                            0600);
> +                               if (nfd < 0) {
> +                                       perror("openat");
> +                                       exit(EXIT_FAILURE);
> +                               }
> +                               if (fstat(nfd, &st) < 0) {
> +                                       perror("fstat");
> +                                       exit(EXIT_FAILURE);
> +                               }
> +                               close(nfd);
> +                               close(ofd);
> +                               exists =3D 1;
> +                               printf("recreated entry %s\n", filename);
> +                       } else if (modify > 0) {
>                                 if (openat(fd, filename, O_CREAT, 0600) <=
 0) {
>                                         perror("openat");
>                                         exit(EXIT_FAILURE);
> @@ -109,6 +213,11 @@ int main(int argc, char *argv[])
>                                 exists =3D 1;
>                                 printf("created entry %s\n", filename);
>                         } else if (modify < 0) {
> +                               if (next && fstatat(fd, filename, &st,
> +                                                   AT_SYMLINK_NOFOLLOW))=
 {
> +                                       perror("fstatat");
> +                                       exit(EXIT_FAILURE);
> +                               }
>                                 if (unlinkat(fd, filename, 0) < 0) {
>                                         perror("unlinkat");
>                                         exit(EXIT_FAILURE);
> @@ -164,8 +273,13 @@ int main(int argc, char *argv[])
>                                                i, d->d_name, (long long i=
nt)d->d_ino,
>                                                (long long int)d->d_off);
>                                 if (!strcmp(filename, d->d_name)) {
> +                                       /* the old fd may list it stale *=
/
> +                                       int stale =3D fd !=3D fd2 && old_=
ino &&
> +                                                   d->d_ino =3D=3D old_i=
no;
> +
>                                         found =3D 1;
> -                                       if (st.st_ino && d->d_ino !=3D st=
.st_ino) {
> +                                       if (!stale && st.st_ino &&
> +                                           d->d_ino !=3D st.st_ino) {
>                                                 fprintf(stderr, "entry %s=
 has inconsistent d_ino (%lld !=3D %lld)\n",
>                                                                 filename,
>                                                                 (long lon=
g int)d->d_ino,
> diff --git a/tests/overlay/077 b/tests/overlay/077
> index 00de0825..6426bc26 100755
> --- a/tests/overlay/077
> +++ b/tests/overlay/077
> @@ -9,6 +9,7 @@
>  # This is a regression test for kernel commits:
>  # 65cd913ec9d9 ("ovl: invalidate readdir cache on changes to dir with or=
igin")
>  # 9011c2791e63 ("ovl: skip stale entries in merge dir cache iteration")
> +# xxxxxxxxxxxx ("ovl: skip stale entries in impure dir iteration")
>  #
>  . ./common/preamble
>  _begin_fstest auto quick dir
> @@ -20,6 +21,8 @@ _fixed_by_kernel_commit 65cd913ec9d9 \
>         "ovl: invalidate readdir cache on changes to dir with origin"
>  _fixed_by_kernel_commit 9011c2791e63 \
>         "ovl: skip stale entries in merge dir cache iteration"
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +       "ovl: skip stale entries in impure dir iteration"
>
>  _require_scratch_nocheck
>
> @@ -40,16 +43,20 @@ create_files() {
>  _scratch_mkfs
>
>  # Create test area with a merge dir, a "former" merge dir,
> -# a pure upper dir and impure upper dir. For each case, overlayfs
> +# a pure upper dir and two impure upper dirs. For each case, overlayfs
>  # readdir cache is used a bit differently.
>  lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
>  upperdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
>
> -mkdir -p $lowerdir/merge $lowerdir/former $upperdir/pure $upperdir/impur=
e
> +mkdir -p $lowerdir/merge $lowerdir/former $upperdir/pure $upperdir/impur=
e \
> +       $upperdir/impure2
>  # Lower files in merge dir are listed first
>  create_files $lowerdir/merge m
>  # Files to be moved into impure upper dir
>  create_files $lowerdir o
> +# Files to be moved into another impure upper dir, which only has entrie=
s
> +# with origin
> +create_files $lowerdir n
>  # File to be moved into former merge dir to make it impure
>  touch $lowerdir/f100
>
> @@ -61,6 +68,7 @@ create_files $SCRATCH_MNT/former f
>  touch $SCRATCH_MNT/merge/m100
>  # Move copied up files so readdir will need to lookup origin d_ino
>  mv $SCRATCH_MNT/o* $SCRATCH_MNT/impure/
> +mv $SCRATCH_MNT/n* $SCRATCH_MNT/impure2/
>  mv $SCRATCH_MNT/f100 $SCRATCH_MNT/former/
>
>  # Remove the lower directory and mount overlay again to create
> @@ -84,6 +92,19 @@ $here/src/t_dir_offset2 $SCRATCH_MNT/impure $bufsize "=
+o0" 2>&1 >> $seqres.full
>  echo -e "\nRemove file in impure upper dir:" >> $seqres.full
>  $here/src/t_dir_offset2 $SCRATCH_MNT/impure $bufsize  "-o100" 2>&1 >> $s=
eqres.full || \
>         echo "Found unlinked file in impure upper dir (see $seqres.full f=
or details)"
> +# Remove the entry that the next getdents call returns first. An ext4 up=
per
> +# with a hashed dir returns it even after it was removed, so this checks=
 the
> +# stale entry case on every hash seed, not only when ext4 happens to kee=
p the
> +# removed file.
> +echo -e "\nRemove next file in impure upper dir:" >> $seqres.full
> +$here/src/t_dir_offset2 $SCRATCH_MNT/impure2 $bufsize "-" 2>&1 >> $seqre=
s.full || \
> +       echo "Found unlinked next file in impure upper dir (see $seqres.f=
ull for details)"
> +# Recreate the entry that the next getdents call returns first. A new fd
> +# must list the name with the d_ino of the new file. The old fd may list=
 it,
> +# with the d_ino of the old or the new file.
> +echo -e "\nRecreate next file in impure upper dir:" >> $seqres.full
> +$here/src/t_dir_offset2 $SCRATCH_MNT/impure2 $bufsize "=3D" 2>&1 >> $seq=
res.full || \
> +       echo "Missing recreated next file in impure upper dir (see $seqre=
s.full for details)"
>
>  # Check readdir cache invalidate on merge dir
>  echo -e "\nCreate file in merge dir:" >> $seqres.full
>
> ---
> base-commit: d07dca72d2455f4ba8c660ad4c008541ccccb707
> change-id: 20261110-ovl077-stale-next-af1a98ce7151
>
> Best regards,
> --
> Daejun Park <daejun7.park@samsung.com>
>
>
