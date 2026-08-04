Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5355481A96
	for <linux-unionfs@vger.kernel.org>; Tue,  4 Aug 2026 17:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785862876; cv=pass; b=BWBFS1z2fu8jfDwk7cbktPCs5ux1iCkYMvAhtVj/PkXwI1jbP8we+S/nfummITV8xoc5lzmxPTZqnvD/axTjfLh2n13uXxxgZrTJEXR5JsgyWsndMb/z/JgzV0YZtm/9eczZDSk/s00v3PjPQmExZB6ycGAO2tIcyrmEqNPx0bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785862876; c=relaxed/simple;
	bh=NN7RQwZEWIcd3u0Kef8iTQYndBZrEjQokV6obVKC/Dc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e4sAf7rPv7sh24jTdycCMNXyPoSDBJZ4Jll7DnDHOY0DG7GjX3Gj2U2xT/yFqeTRwFkqNdlH7TuvLPW9y3bsuvklbhOAVw27KzV0mzf/FjHv+NIWo+PI+ChOrg+p7vbDH0+dXiyG+XeIioYDub916SlEteQLgHId0lIlp32OyI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=SZHhjSu+; arc=pass smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="SZHhjSu+"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-ca957432c7fso3504299a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Aug 2026 10:00:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785862855; cv=none;
        d=google.com; s=arc-20260327;
        b=Mg/fmWK9JX8uOSocjjvE9JVfpPa5ngH2knrsAo7WAlDYglNznVX3MoCkjN7aU9YX4B
         2vyeVK+MXSLRHZBuArD0NZAq3ooPQkIcwwqBebhsOQL6yILsxEq1utF8pjhFpvpDGcEK
         UIVjWL02UYiZi9qKjubzwHHlXibmAfc0uHLixipvhqZwfE+Zg8FqnOiYYCQ2ujCbu7OD
         G4ol1WlqxDfW70mTbrJahbM7tWGIsgmehX+5s9iqca3e5MfI9HzLaMfODSBPKhMHdtO4
         AlpZmcIvRqmEBBBBlOztvzpwfbx7TnlHqG8olUbxMGkFyzeIWsm7+CUN9zsvwPwVEqtT
         b6hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d0whWseHxQspZUWpMNteiPZ9cq9DmnQxMjSfFcf9OVs=;
        fh=y3YuXzkhGR9zzeVgWhS6ntBK+Au4QAvDdx7KosX4cuk=;
        b=NPMfP96q1CLm/5WodkNjnTLVxuPQo2//iEesCVgYER6vGzXo+LOWzKD/yHcoJy+SnS
         XGLJ2BGs7poFLdnwgW4zxxPpf26ud9cEUyD7CA3YfE04A0cTMTykdIA03qlSTi3TviJI
         Y3FBPda6nnE1NzrVVM2WH/dxOi5gcxArMYIOdq56oY+irdLW09Cnc6RA9rRScw2SZHgL
         7QkXr7UdJavj3U9OCJLxparSL2LHhieE7MeC8BODtv+WD4wPI+gZtynLLHiZGZ880HNM
         NTmZxBS+8ohdg5S25bI8wHVYcHC5VOLrwtamPZm1dXluoN1bF/8T4/lpCfgGAlffdJUy
         V1fA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1785862855; x=1786467655; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d0whWseHxQspZUWpMNteiPZ9cq9DmnQxMjSfFcf9OVs=;
        b=SZHhjSu+914kO7qex0mPblU4m6opNNQ8SYzai3bSARLJLgxVPtp34YzgW7oNbu+Fuq
         4k48OU3THdvgN3jqv+jM8b9hg4IuP4x5ZijnVcsu409eI/9qvBshVlFF9iR0I16pcYE9
         8EkVEiEQ0LZ4BthS/SlV0K0QhtVk8no3npBUgkYyjDuhrbnahz6Q6mEKaxT+xuEvfw+O
         HGBFPVy/uByJ5rIO9oNE0+N946LUW2e2Kdacwu07ETwulGTTUCTxb1+jZ4znPHIPIpVC
         FB1jraJdPJh9m/LBOHcBHjtCTxZu8G794pvx/MD3enegq88zBZWC0w0rApfKO0ybDjfA
         3Bnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785862855; x=1786467655;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d0whWseHxQspZUWpMNteiPZ9cq9DmnQxMjSfFcf9OVs=;
        b=PNmcxjJmOAkhNptVg71jpzNPaIT4KbghK4bD042qTCaCu4TQ+N5IljxsA9llZMElHl
         Ibau88Vc6YCIRGO4w6mx4MP7Sjs25mX8KB1qPpA5XeFcqU8gMHqAYy79nMfW5kf28byx
         1TAFrY6zYqsw7680nZS2X+W05cssDACs5rgwb45r1/hJDYkPAdDnGP+rSnn0wJ5aVz3m
         n7J3Yzu2Y4eI6WcgVJFJlAddm5CA3meblHyTuIbqZVBs2NX4F/k/MdVG9kLCqgCc/PIO
         qlGtfFc6K3y07094k3qax/zt1NwnA6ZKJ9WpTC90vJWS4ZDo2JmpM7y1VlzmBie8jYBm
         y68Q==
X-Forwarded-Encrypted: i=1; AHgh+RpfJ+2192BQ/R19qPvEbqBXUW/igxQOtBbLdP/blfCfDDOUnmc+shDL44rFNGt9Pqu13dAkfYGESIxuxnro@vger.kernel.org
X-Gm-Message-State: AOJu0Yww/UaGQY5m2K86qUDAXIPwpC4Wgcs52+RxtXnRAuII9MnjErFB
	HCb7eCK/eU5PLHy1BfKGpfeHbj4XZm6VaGWRCUhxQBfZ9vcJm+o1S7vJJeWzWVWJMOJOtmtzTBv
	Yo7+sxyHLn/HED4qqNgqhWggigia4vFOzEHYGhpkV
X-Gm-Gg: AR+sD10aM6tWmd89l8WaQbI06GH95UeG20OIxRszgKLN/fjhVGfFhJUGxYDx6qwD2w8
	Kz8dqexLOCLE/3RuaL/aJ1H/Ev3AWEMyckHp5xZ47MGCzmRspRZgkDcefHMDwUMAjDNIlMUIoXe
	m+Mj62/hKUrV6zOWtbIpHcuDE0SHFPedQ0KvFi/bdgs9QVW8xuOu6MQyUccc5wmZtiqwZFEkb/2
	bNdP5Ruzh/j2Kev2j5Thy4wKBF2YrpaikipUj4SeKuuzI+6TsCWcYvHperDggYlKaMPlot+FPuC
	SigGpix9wzVzNoVB8DJGUBXJJ4W3KOscwmRm1WQhHug3
X-Received: by 2002:a05:6a21:3204:b0:3c3:834e:89b9 with SMTP id
 adf61e73a8af0-3cb85e7370emr306570637.17.1785862855065; Tue, 04 Aug 2026
 10:00:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804034204.3487077-1-libaokun@linux.alibaba.com>
In-Reply-To: <20260804034204.3487077-1-libaokun@linux.alibaba.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 4 Aug 2026 13:00:43 -0400
X-Gm-Features: AUfX_my2GHODSgWpz7u9PLF5sftBX1mO9fjStT4uqGF3r0dq7sFB5ilyjzEJ3cE
Message-ID: <CAHC9VhTWuX6D0yeBKr0bPbJ_mKUdiLYRtQpcwq-jJgovY_akDA@mail.gmail.com>
Subject: Re: [PATCH] fs: fix user path of nested backing files
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, serge@hallyn.com, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 11:42=E2=80=AFPM Baokun Li <libaokun@linux.alibaba.c=
om> wrote:
>
> backing_file_open() derives the path to be stored in the new backing
> file from user_file->f_path.  This is incorrect when user_file itself
> is a backing file, which is the case for nested stacking filesystems,
> e.g. overlayfs mounts where the lowerdir of one overlayfs is the merged
> directory of another.  Since commit def3ae83da02 ("fs: store real path
> instead of fake path in backing file f_path") the f_path of a backing
> file holds the real path of the intermediate layer, not the path that
> the user opened.
>
> Commit 924577e4f6ca ("ovl: Fix nested backing file paths") fixed this
> for such configurations by passing file_user_path() from
> ovl_open_realfile().  However, commit 6af36aeb147a ("lsm: add
> backing_file LSM hooks") changed the first argument of
> backing_file_open() from the user path back to the user file and
> derived the path from user_file->f_path again, silently re-introducing
> the problem.
>
> As a result, files mapped through a nested overlayfs show the wrong
> path in /proc/<pid>/maps and in perf/ftrace mmap records.  For example,
> with two nested overlayfs mounts:
>
>   mkdir -p /ovl/{lower,upper,work,merged} /ovl/nested
>   echo hello > /ovl/lower/foo
>   mount -t overlay overlay \
>         -o lowerdir=3D/ovl/lower,upperdir=3D/ovl/upper,workdir=3D/ovl/wor=
k \
>         /ovl/merged
>   # at least two lowerdirs are needed when upperdir is nonexistent
>   mount -t overlay overlay \
>         -o lowerdir=3D/ovl/merged:/ovl/lower /ovl/nested
>
> mapping /ovl/nested/foo shows a disconnected path instead of the user
> path:
>
>   # readlink /proc/self/fd/3
>   /ovl/nested/foo
>   # grep foo /proc/self/maps
>   7f6e2c100000-7f6e2c101000 r--s 00000000 00:24 15813027 /foo
>
> The bogus path is derived from the f_path of the intermediate backing
> file, whose mount is a private clone that d_path() cannot resolve.
>
> Fix this by using file_user_path(), which returns the outermost
> user-visible path for backing files and falls back to
> &user_file->f_path for regular files.  This restores the behavior of
> commit 924577e4f6ca ("ovl: Fix nested backing file paths") for
> overlayfs and also fixes the same problem for the other
> backing_file_open() callers, fuse passthrough and erofs ishare, when
> their user file is itself a backing file.
>
> backing_tmpfile_open() has the same pattern but is not affected: it is
> only called by ovl_create_tmpfile() for the upper layer, and another
> overlayfs is rejected as upperdir by the DCACHE_OP_REAL check in
> ovl_mount_dir_check(), so its user_file can never be a backing file.
>
> Fixes: 6af36aeb147a ("lsm: add backing_file LSM hooks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
> ---
>  fs/backing-file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

The selinux-testsuite runs clean with this patch applied.

Tested-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
