From: Vincent Batts <vbatts@gmail.com>
Subject: Re: [PATCH] unionmount-testsuite: test rmdir of non-empty opaque dir
Date: Wed, 13 May 2015 11:35:06 -0400
Message-ID: <CAN6Zp5xCn2GGxkBeOopy_7QaSjkq4XjEqbKn--4kbA-GzfP-Mg@mail.gmail.com>
References: <20150513151502.GB19583@tucsk.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33485 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934434AbbEMPfH (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 13 May 2015 11:35:07 -0400
Received: by wgin8 with SMTP id n8so47796607wgi.0
        for <linux-unionfs@vger.kernel.org>; Wed, 13 May 2015 08:35:06 -0700 (PDT)
In-Reply-To: <20150513151502.GB19583@tucsk.suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>, linux-unionfs@vger.kernel.org

On Wed, May 13, 2015 at 11:15 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> ---
>  tests/rmdir.py |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> --- a/tests/rmdir.py
> +++ b/tests/rmdir.py
> @@ -203,3 +203,19 @@ from errno import *
>      ctx.rmdir(sym, err=ENOTDIR)
>      ctx.rmdir(sym, err=ENOTDIR)
>      ctx.rmdir(d, err=ENOENT)
> +
> +# Remove an empty lower directory, recreate, populate and try to remove
> +def subtest_16(ctx):
> +    """Remove non-empty opaque directory"""
> +    d = ctx.empty_dir() + ctx.termslash()
> +    f = d + "/b"
> +
> +    ctx.rmdir(d)
> +    ctx.rmdir(d, err=ENOENT)
> +    ctx.mkdir(d, 0o755)
> +    ctx.open_file(f, wo=1, crt=1, ex=1, write="abcq")
> +    ctx.rmdir(d, err=ENOTEMPTY)
> +    ctx.unlink(f)
> +    ctx.open_file(f, ro=1, err=ENOENT)
> +    ctx.unlink(f, err=ENOENT)
> +    ctx.rmdir(d)


I'm not familiar with this testsuite. The empty_dir will be on the
lower level, and all the rmdir, mkdir and create are happening on a
mounted union fs? I don't see where that is clear.
