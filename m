Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795123189;
	b=l3ru3ITqa6kZek0MNxMPfprTWF/iRc0Ym29gQeQXU9gZCx9LS3p49Bee3f8UtZOYo1vu
	 Qro3aaIBD+StTUyta2BHIsMQ1IVlO2MKo+oaxNfvV3UC9SR6Bfq+HfKOgDbBM+bwiC3Pv
	 IdIhXo37LJGwyTJQjctu7f5PFo5Lr+d8VxfJ00WgGxASa4YqGLJFKtaodQsHYzzCwArth
	 RAUPfecDqlPhdQ73sq+VQm9Y8EhewjGcwZDGXv26kx7RXXbZli7Wkoz85uDMFv/wf+N91
	 8LzbCYIXor8uBSvrFGWqI7UZcJ4ZaB5HDuBrYv8oFVnKeBvG00g1i8S0LoRP5WduaKA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795123189;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=RRAMHZ4S62Yo6hlTBa8X3X3JUkjgdwr/B0EvJfR6wag=;
	b=G2wGjn0Tviw2DNcXUj1mcXo2zvy7Zh6aVQmBzCRAsGmjeTAdtpeRvvWAU/lF60UvADP3
	 K5A/XQGcpKP36b2r2SLQavznBV8JlXHUlXe1phERjWnaodsfDmzkPs4foMkvE5ap5zc/m
	 KwaQ+yAD9gysgik6xIxv+iWp3RZXCO53JtM8NgZ74p3wYNjtkFw8jiml2EOE8y0YPMCCF
	 H9nFZ303uxUXtulrz107Pxbuh5lKf2dj/T+tHheCq4dOdWz7F6oCFI05sGPa+d6TIfuG2
	 wJrCr9p3KThe1TPaH8WMKy7Sr9i9IukNoNIXsJXk/P/uubfVY2MoQ8noLkTLYMtvoTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=laV1PA5+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57C6606A330
	for <linux-unionfs@vger.kernel.org>; Thu, 19 Nov 2026 21:19:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A57C6606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=laV1PA5+
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b8784a3284so284612a12.1
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Nov 2026 13:19:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795123186; cv=none;
        d=google.com; s=arc-20260327;
        b=X8ru0QQAsWFpuiLlN999AFCtW0sX2YqTM/7TqOqro8gR0/rINrOHqZ54jFHUEMMSjz
         ZkQ888o6jG8E/ToFgA1M8gNqfTitbaFGryJDC/vxQPkxNakb3m3ILuZDHGmmZF2xX5I5
         I6Q2KNaDZeQTmsDiIEFHj47tPQWRkv4yHaM+FxFsDwezDVoO3YoYXT64wcmbyDaN6n8g
         y0acthmm1uUuk9OfLWg6y43gnGyVBdEgfUCWbUtwxLWIv2hHrAudouYet63As5+iF4/b
         20THN7IAkl3PqhpXIuJoi+BaF4jA1htezQHVNOkBVFkc/mR5rGPxyLd6ctI6HpHO3qd+
         zx7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RRAMHZ4S62Yo6hlTBa8X3X3JUkjgdwr/B0EvJfR6wag=;
        fh=alLYOB5zSieQ5bkMaMTQ12gVZmVRbUpo8kghH4U67+I=;
        b=bPFAnTrDtm9vtAqaBFbPoxtkLnQx+jZ1U1e1WbIXukL8XcmNtiRONONTx1Nq2f46nF
         vl2+DjiFgwZJ/UtprsyCim3xbcWW4I+7LdS1JPTFmUOkWT0tkJqtaOP4G6GYlEKuc5eq
         nhkudwSs+gzMdlH6pgUiXYoBM8+oDlzfMlW/fW6cA9X4KHmDNfRdRLP8lBW/BbCSV6ve
         i3LwN+MgyiX0ad7gfHHEMN3Xdf9UatnioPJbfUqDhH1qDdkZc37zoPoPGwgX+qJdfveK
         5MWD1fcMyaZIqeCbNMbXF2l0r3p2QukDVYvhslRz1se0Kg9WnSFJQMbM99d5XFymJi5V
         ZVFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795123186; x=1795727986; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RRAMHZ4S62Yo6hlTBa8X3X3JUkjgdwr/B0EvJfR6wag=;
        b=laV1PA5+3hmc33X0BGaxCjFqIr5MqJ14e9KVgBgQUD6w5FPHWNELug37pi66yNshOO
         UtoE7UWwEKSpcQzNeUxWJAM3bhT7HkJCAiU7OdWbJ79b6RYYSVd09QkI4F3kjHNd4uIJ
         A0KOX+/nviYNRwIn7i1u3U6DQtbJdNgm4kx11uMbKZBHvDHA07UCEtp+8s8J/3ftTkyD
         0b33uNay84cp3nATACTYqENsjxWmuERBUTYceTcNXmaT6SW5O3j5ZxtuAh/nT+jMUBp5
         kDvnqi6gOWlZGQrvzdF6yRmGtb/ByUm74fSXPlcNdy0Xq9hzQ1JF4+mE/rkIADt6bUc/
         F0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795123186; x=1795727986;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RRAMHZ4S62Yo6hlTBa8X3X3JUkjgdwr/B0EvJfR6wag=;
        b=QJHeJoPl2GdZG292xzX2d+mZ0my5bSZXTxM14S6JgyeNPS5IS5X8u+Nk22u4Z67wwV
         7j+EeCVY9pj+tj3Y91Ab0+JNu5gPWGqy+0+448yjfEhG1HmN8ErPaHVS0DMl/uKbQ1H9
         91gjdOejx8Z+PV3lg1SawpsFv+MnzbjF0VXZybk0x0sdIfDWN1ztvPqsZSF830GFB9vM
         XxbirH+x9xuvYZtaSDmQTXeYxzcpn+IC/YClC7x+e9OuVxubxEpfrX+UteqicOHt0VN6
         aV1n52D4nYd3VH4NsTje33fMlO4QSPKk7sSwZTidKDG9yRhOdv+QDUPfTjyOeieZMPla
         kI2w==
X-Forwarded-Encrypted: i=1; AL+hErEWSmTZvuhZggnvMO71A7wwKuShmAa1VwVQTIH7vqbwVTGil2geWBCLExek1zHrqwFCrIa9q5282TSmWft6@vger.kernel.org
X-Gm-Message-State: APuU4Z+ANbJVH9+MG0+FWf2yNvS/g5XmO77hdSaTI+vXZtL7uMsh36su
	V32EwEqi48/Q0UB1nbGnJ+lNaDW1lKrEmqzS/tzRevCGyefMP/JkYpYlQECQFZy/kSE/ax7buU/
	CVVlRQcAzskU5CtMPQnQ3wBrtdewb9/E=
X-Gm-Gg: AYBFou2oc0z+BsUl4smjo474imu1uF6ZoQmvIDTpzv9I45ANePzynC2JWE29ZPi9g0Z
	f2Q9yrpFI3ijW8p4vQRrMkPFYdtF47e8rKzYGV5GtXTVirxv0nWOr82VgaAXsImfCWW0v4kZJMl
	vvIHaf4HcnXTymOhDDsMC+Vjqzj+KCu+Rj3dUVtNxnxIPjmUEJxGp1xQ+EHNMSQ2XcHr/5sJflz
	/F/R2iJ7HiRulAexIdRfQ9ZlgFF7xhxLUnGj2Y3UvOdvxmdexJviK2nn3MSuba1p8EoBbCm0F3h
	bx34u3T/Oqs+cCfq2TPVk5a1Za67GnkpOlg/vkoGQtLsr8TjflHorWwAXenrh1P5uDsCqYdKpvm
	5tsq1i3ndXhKhevWkpDFWJ11zZU7DwiO9JP+MbFBG9AgVgzQDENYfmsA4Eav7S7ysjSUY/A==
X-Received: by 2002:a05:6402:4052:20b0:6b5:876c:a98f with SMTP id
 4fb4d7f45d1cf-6ba37ee52e4mr405100a12.34.1795123185728; Thu, 19 Nov 2026
 13:19:45 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAOQ4uxjHwtZEHu9xMM6zg9niSgNdLXhAu65jA8Ai_SKVg-W2nw@mail.gmail.com>
 <20261119183039.1505892-2-ptikhomirov@virtuozzo.com>
In-Reply-To: <20261119183039.1505892-2-ptikhomirov@virtuozzo.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Nov 2026 22:19:34 +0100
X-Gm-Features: Aa3M54qPR6beAzPiPDvVeM7eC1sDIvJDE2oypEtexE164vDya4GKLsVUqI-JH_g
Message-ID: <CAOQ4uxjj9inY=n-WP83_sYpuZBLKumxqiVACpseKuB2hkW-Auw@mail.gmail.com>
Subject: Re: [PATCH] selftests/cachestat: add overlayfs test cases
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ding Feng <dingf3ng@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 7:34=E2=80=AFPM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> Run cachestat() on overlayfs files in four variants. The file is written
> either to the lower dir of an overlayfs or through its mount, so its
> page cache is in the lower or in the upper dir. Then it is opened
> read-only, so it is not copied up, and checked:
>
> - through the overlayfs mount: the page cache is one stacking level
>   down;
> - through a second overlayfs mount, which has the first one's merged dir
>   as its lower dir: the page cache is two stacking levels down.
>
> Overlayfs does not cache file data in its own inodes, so cachestat()
> sees the pages only if it is forwarded to the real file.
>
> Add a check_cached argument to test_cachestat() to check the pages of a
> file the test did not write itself, and bump NR_TESTS to the actual
> number of tests (it was 9 while ten were already run).
>
> The test rework and the changelog were drafted with the help of an AI
> coding assistant (Claude); the result was reviewed and tested by me.
>
> Link: https://lore.kernel.org/r/20261118123105.1247627-1-amir73il@gmail.c=
om/
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
> v2:
> - Rework of patch 3/3 of v1 on top of Amir's ->f_real() patch; the
>   ->cachestat() file operation from patches 1-2 is replaced by it.
> - Add lower file and nested overlayfs cases, and a check_cached argument
>   to test_cachestat().
> v1: https://lore.kernel.org/r/20260623111533.2285005-1-ptikhomirov@virtuo=
zzo.com/
>
> The nested cases pass only with Amir's ovl_f_real() recursion fix
> (https://lore.kernel.org/r/CAOQ4uxjHwtZEHu9xMM6zg9niSgNdLXhAu65jA8Ai_SKVg=
-W2nw@mail.gmail.com/)
> plus EXPORT_SYMBOL(__file_real) when overlayfs is a module; on Amir's v1
> alone they fail with "Cached: 0".

Posted v2 with your Tested-by:

https://lore.kernel.org/linux-fsdevel/20261119211542.1509119-1-amir73il@gma=
il.com/

Christian,

Please apply Pavel's test along with the file_real() patch.

Thanks,
Amir.

> ---
>  .../selftests/cachestat/test_cachestat.c      | 172 +++++++++++++++++-
>  1 file changed, 163 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/t=
esting/selftests/cachestat/test_cachestat.c
> index 542cd09cb4434..af8fa21c90ca1 100644
> --- a/tools/testing/selftests/cachestat/test_cachestat.c
> +++ b/tools/testing/selftests/cachestat/test_cachestat.c
> @@ -4,27 +4,42 @@
>
>  #include <stdio.h>
>  #include <stdbool.h>
> +#include <stdlib.h>
>  #include <linux/kernel.h>
>  #include <linux/magic.h>
>  #include <linux/mman.h>
>  #include <sys/mman.h>
> +#include <sys/mount.h>
>  #include <sys/shm.h>
> +#include <sys/stat.h>
>  #include <sys/syscall.h>
>  #include <sys/vfs.h>
>  #include <unistd.h>
>  #include <string.h>
>  #include <fcntl.h>
>  #include <errno.h>
> +#include <limits.h>
>
>  #include "kselftest.h"
>
> -#define NR_TESTS       9
> +#define NR_TESTS       14
>
>  static const char * const dev_files[] =3D {
>         "/dev/zero", "/dev/null", "/dev/urandom",
>         "/proc/version", "/proc"
>  };
>
> +static const struct {
> +       bool lower;
> +       bool nested;
> +       const char *desc;
> +} ovl_tests[] =3D {
> +       { false, false, "an overlayfs file" },
> +       { false, true, "a nested overlayfs file" },
> +       { true, false, "an overlayfs lower file" },
> +       { true, true, "a nested overlayfs lower file" },
> +};
> +
>  void print_cachestat(struct cachestat *cs)
>  {
>         ksft_print_msg(
> @@ -117,10 +132,14 @@ static bool is_on_tmpfs(int fd)
>   * Open/create the file at filename, (optionally) write random data to i=
t
>   * (exactly num_pages), then test the cachestat syscall on this file.
>   *
> + * If write_random =3D=3D true or check_cached =3D=3D true, check that a=
ll num_pages
> + * pages of the file are cached or evicted.
> + *
>   * If test_fsync =3D=3D true, fsync the file, then check the number of d=
irty
>   * pages.
>   */
> -static int test_cachestat(const char *filename, bool write_random, bool =
create,
> +static int test_cachestat(const char *filename, bool write_random,
> +                         bool check_cached, bool create,
>                           bool test_fsync, unsigned long num_pages,
>                           int open_flags, mode_t open_mode)
>  {
> @@ -161,7 +180,7 @@ static int test_cachestat(const char *filename, bool =
write_random, bool create,
>         } else {
>                 print_cachestat(&cs);
>
> -               if (write_random) {
> +               if (write_random || check_cached) {
>                         if (cs.nr_cache + cs.nr_evicted !=3D num_pages) {
>                                 ksft_print_msg(
>                                         "Total number of cached and evict=
ed pages is off.\n");
> @@ -294,6 +313,122 @@ bool run_cachestat_test(enum file_type type)
>         return ret;
>  }
>
> +static int mount_overlayfs(const char *lowerdir, const char *upperdir,
> +                          const char *workdir, const char *merged)
> +{
> +       char opts[4 * PATH_MAX];
> +
> +       snprintf(opts, sizeof(opts), "lowerdir=3D%s,upperdir=3D%s,workdir=
=3D%s",
> +                lowerdir, upperdir, workdir);
> +       if (mount("overlay", merged, "overlay", 0, opts)) {
> +               ksft_print_msg("Unable to mount overlayfs (need root?): %=
s\n",
> +                              strerror(errno));
> +               return KSFT_SKIP;
> +       }
> +
> +       return KSFT_PASS;
> +}
> +
> +/*
> + * Write a file to an overlayfs, either directly to its lower dir (if lo=
wer)
> + * or through the overlayfs mount, so that its page cache is in the lowe=
r or
> + * upper dir. Then open the file read-only, so it is not copied up, thro=
ugh the
> + * overlayfs mount or, if nested, through a second overlayfs mount on to=
p of it
> + * (using the first one's merged dir as its lower dir), and run cachesta=
t on
> + * it. Overlayfs does not cache file data in its own inodes, so cachesta=
t sees
> + * the pages only if it is forwarded one (or two, if nested) stacking le=
vels
> + * down, to the page cache belonging to the real file.
> + */
> +static int run_cachestat_overlayfs_test(bool lower, bool nested)
> +{
> +       char tmpl[] =3D "/tmp/cachestat_ovl.XXXXXX";
> +       char lowerdir[PATH_MAX];
> +       char upper1[PATH_MAX], work1[PATH_MAX], merged1[PATH_MAX];
> +       char upper2[PATH_MAX], work2[PATH_MAX], merged2[PATH_MAX];
> +       char cmd[PATH_MAX + 16], file[PATH_MAX + 16];
> +       const char *write_path, *read_path;
> +       char *base;
> +       int ret;
> +
> +       base =3D mkdtemp(tmpl);
> +       if (!base) {
> +               ksft_print_msg("Unable to create overlayfs base dir: %s\n=
",
> +                              strerror(errno));
> +               return KSFT_FAIL;
> +       }
> +
> +       snprintf(lowerdir, sizeof(lowerdir), "%s/lower", base);
> +       snprintf(upper1, sizeof(upper1), "%s/upper1", base);
> +       snprintf(work1, sizeof(work1), "%s/work1", base);
> +       snprintf(merged1, sizeof(merged1), "%s/merged1", base);
> +       snprintf(upper2, sizeof(upper2), "%s/upper2", base);
> +       snprintf(work2, sizeof(work2), "%s/work2", base);
> +       snprintf(merged2, sizeof(merged2), "%s/merged2", base);
> +
> +       if (mkdir(lowerdir, 0755) || mkdir(upper1, 0755) ||
> +           mkdir(work1, 0755) || mkdir(merged1, 0755) ||
> +           mkdir(upper2, 0755) || mkdir(work2, 0755) ||
> +           mkdir(merged2, 0755)) {
> +               ksft_print_msg("Unable to create overlayfs dirs: %s\n",
> +                              strerror(errno));
> +               ret =3D KSFT_FAIL;
> +               goto cleanup;
> +       }
> +
> +       if (lower)
> +               write_path =3D lowerdir;
> +       else
> +               write_path =3D merged1;
> +
> +       if (nested)
> +               read_path =3D merged2;
> +       else
> +               read_path =3D merged1;
> +
> +       snprintf(file, sizeof(file), "%s/cachestat", write_path);
> +
> +       /* Write the lower file before mounting overlayfs over it */
> +       if (lower) {
> +               ret =3D test_cachestat(file, true, false, false, false, 4=
,
> +                                    O_CREAT | O_RDWR, 0600);
> +               if (ret !=3D KSFT_PASS)
> +                       goto cleanup;
> +       }
> +
> +       ret =3D mount_overlayfs(lowerdir, upper1, work1, merged1);
> +       if (ret !=3D KSFT_PASS)
> +               goto cleanup;
> +
> +       if (!lower) {
> +               ret =3D test_cachestat(file, true, false, false, false, 4=
,
> +                                    O_CREAT | O_RDWR, 0600);
> +               if (ret !=3D KSFT_PASS)
> +                       goto umount;
> +       }
> +
> +       if (nested) {
> +               ret =3D mount_overlayfs(merged1, upper2, work2, merged2);
> +               if (ret !=3D KSFT_PASS)
> +                       goto umount;
> +       }
> +
> +       snprintf(file, sizeof(file), "%s/cachestat", read_path);
> +       /* Look at that page cache through the overlayfs layer(s) */
> +       ret =3D test_cachestat(file, false, true, false, false, 4,
> +                            O_RDONLY, 0);
> +
> +       if (nested)
> +               umount(merged2);
> +umount:
> +       umount(merged1);
> +cleanup:
> +       /* Best-effort recursive cleanup of the temporary tree. */
> +       snprintf(cmd, sizeof(cmd), "rm -rf %s", base);
> +       if (system(cmd))
> +               ksft_print_msg("Unable to clean up %s\n", base);
> +       return ret;
> +}
> +
>  int main(void)
>  {
>         int ret;
> @@ -317,8 +452,8 @@ int main(void)
>         for (int i =3D 0; i < 5; i++) {
>                 const char *dev_filename =3D dev_files[i];
>
> -               if (test_cachestat(dev_filename, false, false, false,
> -                       4, O_RDONLY, 0400) =3D=3D KSFT_PASS)
> +               if (test_cachestat(dev_filename, false, false, false, fal=
se,
> +                                  4, O_RDONLY, 0400) =3D=3D KSFT_PASS)
>                         ksft_test_result_pass("cachestat works with %s\n"=
, dev_filename);
>                 else {
>                         ksft_test_result_fail("cachestat fails with %s\n"=
, dev_filename);
> @@ -326,16 +461,16 @@ int main(void)
>                 }
>         }
>
> -       if (test_cachestat("tmpfilecachestat", true, true,
> -               false, 4, O_CREAT | O_RDWR, 0600) =3D=3D KSFT_PASS)
> +       if (test_cachestat("tmpfilecachestat", true, false, true,
> +                          false, 4, O_CREAT | O_RDWR, 0600) =3D=3D KSFT_=
PASS)
>                 ksft_test_result_pass("cachestat works with a normal file=
\n");
>         else {
>                 ksft_test_result_fail("cachestat fails with normal file\n=
");
>                 ret =3D 1;
>         }
>
> -       switch (test_cachestat("tmpfilecachestat", true, true,
> -               true, 4, O_CREAT | O_RDWR, 0600)) {
> +       switch (test_cachestat("tmpfilecachestat", true, false, true,
> +                              true, 4, O_CREAT | O_RDWR, 0600)) {
>         case KSFT_FAIL:
>                 ksft_test_result_fail("cachestat fsync fails with normal =
file\n");
>                 ret =3D KSFT_FAIL;
> @@ -361,5 +496,24 @@ int main(void)
>                 ksft_test_result_fail("cachestat fails with a mmap file\n=
");
>                 ret =3D 1;
>         }
> +
> +       for (int i =3D 0; i < ARRAY_SIZE(ovl_tests); i++) {
> +               const char *desc =3D ovl_tests[i].desc;
> +
> +               switch (run_cachestat_overlayfs_test(ovl_tests[i].lower,
> +                                                    ovl_tests[i].nested)=
) {
> +               case KSFT_FAIL:
> +                       ksft_test_result_fail("cachestat fails with %s\n"=
, desc);
> +                       ret =3D 1;
> +                       break;
> +               case KSFT_PASS:
> +                       ksft_test_result_pass("cachestat works with %s\n"=
, desc);
> +                       break;
> +               case KSFT_SKIP:
> +                       ksft_test_result_skip("overlayfs not available fo=
r %s\n",
> +                                             desc);
> +                       break;
> +               }
> +       }
>         return ret;
>  }
> --
> 2.56.0
>
