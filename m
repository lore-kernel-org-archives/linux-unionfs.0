Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794479321;
	b=AU5W7eOyTwyIEFSpsZMvMZ3f7f/Q5Dc9nJymoQMMq16FA+7mf9eJhbXMRt9TCGqhkLeu
	 zXv9BAwmH2eO63tWfWFdO2vb3mLD88VeG4NW9J5uuGi6GRQVZAe7UlZEfszilXSRHNuNn
	 xh7pSKIckQ5jCL1SoTNdrzM8W/z/T3ya5y2peaY0g+SuZFR/CL+7O597IYL6KqjBlxwfb
	 svAopbcVlhagCtpLHQMqTjO2fKg8uPkDINapVUncaLUxWY40aoKkwQJGrT+MliN5nMb6V
	 ccvzVOuP4puTWuaUY1CkGbjOCNJJHhieOmQcUCwxCbzTbtaoaTFzBVSA5/Y+Tjc2Dgg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794479321;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Qqba/lXRxsD53ltOSULyqjeFnRQJEmzpMweaXoKnG1o=;
	b=WwqjAQ3mhM0mRsonjRXahJUma8vAlPpA0xi5MqHHmBdJDvcLcfp8JtBf+1xY1xHoYCPb
	 YBAyOjJBhyHT2gY5MucbH208W/QCUrvRGNnH4jQNS6jTbQyqJ1TqW9AqCDmCoVAkbneQ2
	 WKObxGZAr+HG9O0P58v2RfjdikxhaibKTl8b8auUXWQb0a9ZHDSvt9q2WFNk5zUgr6CmX
	 kfzDkpHb648kjASVRBJEawp/Si3x0Wqhz2lvJ4ePl+Qta6ZI4Lf1cKRbnc0yXqTe/3EXL
	 hX18+IYLZQTD1cWo0Q0fawIlt/a+nTdN2MjLctQXfEb8iEHgNjsf7wZ6NJXqeew36kw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CmwNF7GT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E4F606A323
	for <linux-unionfs@vger.kernel.org>; Thu, 12 Nov 2026 10:28:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21E4F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CmwNF7GT
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b596569640so1252995a12.1
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Nov 2026 02:28:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794479319; cv=none;
        d=google.com; s=arc-20260327;
        b=pyD/g+CV9Ltv1Lk8Q6ziXXBTQjmhqJQ/Gw6p+ZgSv2Ai8YI7mdsco08D8AjOjc2lN5
         THmoimEFRTdDMZRd+3tNjY8Puzs1mUg31R/ltS00K86UGDPOxm7tJmgiwCPhHY3OCvpZ
         f9FuzvJ5g+QQtRu6LS6c5+esHmrzNRYUAU/AEQmME4xHKdSibuAoK+giOviI0gCUuwhP
         smgw4juys5hf7xGKTRYM3yH+bDIxaV5AB9PHBnhNJH9jo18UbBUS8uJFMS8JCKz1LElt
         geKLvRucmpSNBX9+Kn5tRgWpeCoN7CBSKkxnnxDINsWp5EQw0BYlVif/PU9jQrWQiVQP
         YgqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qqba/lXRxsD53ltOSULyqjeFnRQJEmzpMweaXoKnG1o=;
        fh=0wCHSUr9SnWkeeNQeb4q05VYowKTK61M6twMLRpY0KA=;
        b=oYNU4bmj49Mh7/aFaxhXGCCqMwaE9f7tpicC81pIQE5eh45x75dRsHjdrLVt7MtqYA
         WGmv43/cRA9xZcqZGfAOtUx+CEXlWJEsu4YjZ0FtbQhIIfwrSMuztEld0ytFo47wJIue
         t/sRVl6EWLPxNHZSYYs7IqJ1tnSPvf4ld2u7MeB3ijWS0GLofBcmVix2iUvO9a/1AuZf
         XBxm68r6NOHc0zfbF5gV/aBKt6NT5YEuzDBSWyRQAn+SiOr6fgNo72anJQTVsfHInkQ1
         hOESxFyOA5ajsjj2iWILSgsdWQky0vmZa1WmFsJJ0TjUz2thz7bTRa7CWdZBz579pRD9
         PDlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794479319; x=1795084119; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qqba/lXRxsD53ltOSULyqjeFnRQJEmzpMweaXoKnG1o=;
        b=CmwNF7GTQ0eDhTzXxJVlYKYWqSmUmx/f2F2RC+H8CI43dqzTTdvXhCnch81BGhA2yV
         SMDmxlaVKvxpUrwG6a773twZoIrp3ZpV4NHZdSjNIGn66G5+CK2ufDcPUq1eG79vGqly
         OnmLB50fcw7xbJU9iuRsWq9XFbh3eDo/Amib05AbYa5WpQvCHTVEqAoFSB+wCMJXUhem
         yxZ0pTD7Uu0CCwLnJcxU/zC0ssaMoJFOwRVYZKcLoRrUJ5imGVlXLGUVZXuEYHcWLzy3
         WRyRJcoqnWCfUc833aqxunFABuapGo4iweUbQHVabU0fEm0u93Q8KfXGyGSiTcdNMfgc
         2N5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794479319; x=1795084119;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qqba/lXRxsD53ltOSULyqjeFnRQJEmzpMweaXoKnG1o=;
        b=jLvjVo6UT2FZPaopDF8qAo/pPM9PzU/SujvX0KRg2koOcyaSqmuM6CnBCUv8rh6r20
         j7xxpPcJEdCI8lQUIMU0qoFlmzsOK5PP0cul43zygqUdYOof7l0gDVLl0SDRK5zlri5L
         Gay/ZMXYhqbFHamQM9k3RXD5dxL0swkKqdSXISuKGjTyPulfDfHoNB+hWvU3ROaWwKpx
         Pxn0GQD/InfR23cV5mq2QuJR6vtenbvhgSBpiNJFpO2Fsc80+6nAxFfC0Fnlly0I85XZ
         XE9/xpGP7VO4QygpGCWSZ0rbhS5Icp0UMSd1gNpV0f2g6k8zbEm0LAzKVbD15Jaq+mMk
         YfDQ==
X-Forwarded-Encrypted: i=1; AL+hErFb2d44NR5SikEPKCafvRgRmkMc63d7P2k9YcBeG2BrtxbnTQuezA0PzYEeKLAHCdUBERmND+JdfAhfFD3C@vger.kernel.org
X-Gm-Message-State: APuU4Z8h82goXzDXKxlpYA/enXwXzS9Pr8Pb0FIAaWTXwhSlml4ulu3Z
	451eYBWcf0CgZOJAj83NBNgnHjcsRGxh1ytMEJTdLH+zpxdMkYaUZfLu0ZGtH1KzUeFLHmcU6rS
	pYbSGTvBWPHyH1x64YU465FDVWAURnMM=
X-Gm-Gg: AYBFou0BRQTOdNMXtn504A6MuzCYD7hYjd8Fymurm6NArVYjkq76rULbU4ssaXwicnI
	zE3leFGYnpQLjvHvVUdU8XZ58SD5yieFOAZOa4zq1LZhW+J4rzZelc9Llf5SaiMk5O16zjv6df/
	hYMruIhIsDtWkNLhYfCdgeFmqmTCtvXIAHGChHTPxk8vUO9Uiu4jpJAAmeIa/N+3C0zF1iRV/9H
	ii+5kCNxCfO9UnsPulc/5VjAVmBEG1ilmQe/NKO9EYvXsttEv6qxF8l7Q133wRRQqrKPw6d7Tvp
	DPQ7Jv9Ne8uvYqVAqHx+zxl24b+2Yc2DsXcbQezVu34rdwOQtdzTs2ulb0ZQA5XBlK72cVXmf2X
	K2gwADpePIGlCBGBg/4FF9ufAWj9E1lXusfYokpMbTGz/j4Gta8IGnYiMZTrbfYUCSVaIBg==
X-Received: by 2002:a05:6402:5650:b0:6b5:8c7c:d540 with SMTP id
 4fb4d7f45d1cf-6b79e055c85mr1170884a12.13.1794479319255; Thu, 12 Nov 2026
 02:28:39 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112-ovl077-stale-next-v2-1-6d3a691a92df@samsung.com>
In-Reply-To: <20261112-ovl077-stale-next-v2-1-6d3a691a92df@samsung.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 12 Nov 2026 11:28:28 +0100
X-Gm-Features: AclHuK_Jiii_kQNNfKuUgdNx_n9aKy2EieH8p6_MXNW-ps6k7W-wF2dVDM_jK3s
Message-ID: <CAOQ4uxiJ4+i+X8O8qxzp-EE8JRvqZSDom97qSRvPfh4mtadefA@mail.gmail.com>
Subject: Re: [PATCH v2] src/t_dir_offset2: do not check d_ino of a stale first entry
To: daejun7.park@samsung.com
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Hungyu Lin <dennylin0707@gmail.com>, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 5:14=E2=80=AFAM Daejun Park via B4 Relay
<devnull+daejun7.park.samsung.com@kernel.org> wrote:
>
> From: Daejun Park <daejun7.park@samsung.com>
>
> overlay/077 fails on ext4 with some directory hash seeds:
>
>     entry o100 has inconsistent d_ino (131181 !=3D 524491)
>
> ext4 returns the entry that did not fit in a getdents buffer first in
> the next call, even if it was unlinked in between. In an impure dir
> overlayfs lists that stale entry with the upper inode number. POSIX
> leaves it unspecified whether readdir() returns such an entry.
>
> Do not check d_ino of that entry.
>
> Reported-by: Hungyu Lin <dennylin0707@gmail.com>
> Closes: https://lore.kernel.org/linux-unionfs/CAGEkeHcg06kHshHQ=3D9U6Yrs_=
wm8W9H28o9bcC2Qh3fw3tANbWA@mail.gmail.com/
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Thanks!

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
> On v7.4-rc2 with ext4, overlay/077 failed on hash seeds ...88bf,
> ...8863 and ...886e and passes now (3 runs each). generic/257 and
> generic/637 pass on ext4 and on overlay. With the stale entry mark of
> commit 9011c2791e63 removed, overlay/077 still reports m100 or f100 on
> ext4 (seeds ...8812, ...884a, ...88bf and a random one) and on xfs.
>
> Changes in v2:
> - New subject. v1 was "overlay/077: check a stale entry in an impure
>   dir on any hash seed".
> - Dropped the "-" and "=3D" cases and the second impure dir.
> - Relaxed the d_ino check instead (Amir), but only for the first
>   entry of the first call after the unlink, where ext4 returns the
>   stale entry. Relaxing the first entry of every buffer hid the
>   regression that 9011c2791e63 fixed on some hash seeds.
> - This no longer waits for a kernel change.
> ---
>  src/t_dir_offset2.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/src/t_dir_offset2.c b/src/t_dir_offset2.c
> index 026bc8f3..a6091f7a 100644
> --- a/src/t_dir_offset2.c
> +++ b/src/t_dir_offset2.c
> @@ -46,6 +46,7 @@ int main(int argc, char *argv[])
>         struct linux_dirent64 *d;
>         struct stat st =3D {};
>         int bpos, total, i;
> +       int ncalls =3D 0;
>         off_t lret;
>         int retval =3D EXIT_SUCCESS;
>         const char *filename =3D NULL;
> @@ -96,6 +97,7 @@ int main(int argc, char *argv[])
>                         perror("getdents");
>                         exit(EXIT_FAILURE);
>                 }
> +               ncalls++;
>
>                 if (modify && fd2 < 0 && total =3D=3D 0) {
>                         printf("getdents at offset 0 returned %d bytes\n"=
, nread);
> @@ -165,7 +167,18 @@ int main(int argc, char *argv[])
>                                                (long long int)d->d_off);
>                                 if (!strcmp(filename, d->d_name)) {
>                                         found =3D 1;
> -                                       if (st.st_ino && d->d_ino !=3D st=
.st_ino) {
> +                                       /*
> +                                        * The file is unlinked after the=
 first
> +                                        * call. A filesystem may still r=
eturn
> +                                        * the entry that did not fit in =
that
> +                                        * buffer first in the second cal=
l. In
> +                                        * an impure dir overlayfs lists =
such a
> +                                        * stale entry with the upper ino=
de
> +                                        * number, not the st_ino seen be=
fore.
> +                                        * Skip the check for that one en=
try.
> +                                        */
> +                                       if (st.st_ino && d->d_ino !=3D st=
.st_ino &&
> +                                           (exists || bpos || ncalls !=
=3D 2)) {
>                                                 fprintf(stderr, "entry %s=
 has inconsistent d_ino (%lld !=3D %lld)\n",
>                                                                 filename,
>                                                                 (long lon=
g int)d->d_ino,
>
> ---
> base-commit: 71641219a506ac62bfa231592394265ca812670e
> change-id: 20261110-ovl077-stale-next-af1a98ce7151
>
> Best regards,
> --
> Daejun Park <daejun7.park@samsung.com>
>
>
