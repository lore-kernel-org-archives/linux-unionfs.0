Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E604C288514
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 07:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763104731; cv=none; b=bw0Wm47Xtr79V6kXo0R8i+2MNma6khDHZWtk02dr/mCUnGezDA+Cdmx8lSChDRygtvmZ1ULHp0OF9sD3ZSM4rjk6WuwHXa4kap219WOVYBJm8V2FX1BmulZJ5YfYgm9CGaPBwM7s3XxEFwDJnPvzEGqtTCfuvUqj/0kVVHXtja0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763104731; c=relaxed/simple;
	bh=pBruvPUEk9sdm7ojTRfuAmE5tz4M39hzPy9nFvCgxXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GKsYEGLkucnP2biCAbdgnrPblubIk8xRPskS4/mpL5JQyQdQI6UTcQwdV21H3CZtPAh6ICC4TuB/bB7wmsVHcGIDEGxZO2KJRx8hjce8AxB8mn/1W8LY5eI173NK5JSaoUuwwrHd05BG/Bn0i3QZsob/mcRV5faCzkRSD3YKNWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=JywJOkRZ; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="JywJOkRZ"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88246676008so20064426d6.3
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 23:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1763104726; x=1763709526; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RSUC6I/0xtkTFjc0S9sYd9t9bOQZ6fRfLXdwbkZEqCo=;
        b=JywJOkRZMMuhTpFpEvs34qunX7J3CRQqIzA25kMCrRs3AtHzNRpbAezcS2m9b3vqMo
         CmLtxXyLfNfcItKN20LU1GAwHi5Sha2MqsY482dcNQgVZeQKGGIuiVTLiqAC9Oh4YpK7
         kGeqS354X0K9TR/nUQILU6uXomY1FYAoWu2dM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763104726; x=1763709526;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RSUC6I/0xtkTFjc0S9sYd9t9bOQZ6fRfLXdwbkZEqCo=;
        b=ao2/c0JdI1mQV1BLoiwq+mR7ujyLswW+6JH2+ymdRzq1vW/FB7z1eb3stwCWYthrvW
         nM2YAY4ZeeCOWlmuJyzsgkG8KiH9eIlQFqYmDBUUWaOVCCUGiOndG6uRaHknrZLHuYq6
         8+RnWjUW1GOtrxSUFoD1ouXu2u5Z/SzCld5f4qTl71n1Bc8PckaGos7iB4JwOeV8IbY3
         zOKa4jIBSKqVWP2Z6B7xUxGJjzJ+2upShFDgT12dnvk4Y0MdWS+per9I6XEBdWeZtUl8
         +FPKPg5UdZyDSmSABYBpy50DEJMUOjsCONsfYt017Ayo5a9hsALvfn8FrzDo4ecJ/PvQ
         F+BQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5PI8SDdz57hxix2Tv50CgNf78XPg1/B3r6G3DWJquLOGJNYTV20aNJqVDJpUeDn3ODbEgsw60Urr2nbgF@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/UcILhSIvTkA1hyHxeXcnclqnfyuqfvX+Hi1PqZySEYCP0hsW
	kxLSCnES997pQiwMEkHJ+3wIIyz4CwSmRwqF40p74hHrFyzf6bOSsFo2cG9WectoDvYYkTteEGM
	wUVi/PQwJoayXtBXqam2Z6+6WX34KGjw4TTh4VWju+Q==
X-Gm-Gg: ASbGnctxELB0Wxfk4o4zcS4hd75zazXLQVpQvT3XafpR83X3V6LGZ5/ApUVZXGMefEh
	TVBplYNNVafzBRdoZfgrK2Pa1EIrUpmpXxEXupc8lwT9GL+MfKrw6Hdq0/2MU2SF/RxoNy0eIaL
	t8z8Wt/MIRrIr00LmAFw43Z+HetoVACJvAf5uA7np6cfvuYQ66lPvRy3H42XdF9BGclnfO2Xqal
	njM9uT+JPs7w60uRV/d3WHcY69uJDmWDZJIIX4QUEddohQEaUyimJ2x3gmj/+F6cQf9
X-Google-Smtp-Source: AGHT+IH9defKmC5r+LJeQ1e6mdHLF4LbeJoqfB5vpMC/YabfqRZyvpmEh8pDIVCEspEp39Qry07R+fhopAd9kUSsFWM=
X-Received: by 2002:ac8:5e0d:0:b0:4ed:d2b:d43f with SMTP id
 d75a77b69052e-4edf2048479mr32594541cf.7.1763104726664; Thu, 13 Nov 2025
 23:18:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v3-0-b35ec983efc1@kernel.org> <20251113-work-ovl-cred-guard-v3-6-b35ec983efc1@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v3-6-b35ec983efc1@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Nov 2025 08:18:35 +0100
X-Gm-Features: AWmQ_bmo0OzcPAWZX1QwevX3GLs4HxBqX6zuFXDJXLl0cJT40hnDYO9AGPqQCOA
Message-ID: <CAJfpegv=yshvPv432F6ytAcuBLWQnx5MvRQjKenmzg-WafZ_VA@mail.gmail.com>
Subject: Re: [PATCH v3 06/42] ovl: port ovl_create_tmpfile() to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Nov 2025 at 22:32, Christian Brauner <brauner@kernel.org> wrote:

> @@ -1332,27 +1332,25 @@ static int ovl_create_tmpfile(struct file *file, struct dentry *dentry,
>         int flags = file->f_flags | OVL_OPEN_FLAGS;
>         int err;
>
> -       old_cred = ovl_override_creds(dentry->d_sb);
> +       scoped_class(override_creds_ovl, old_cred, dentry->d_sb) {
>                 new_cred = ovl_setup_cred_for_create(dentry, inode, mode, old_cred);
> -       err = PTR_ERR(new_cred);
> -       if (IS_ERR(new_cred)) {
> -               new_cred = NULL;
> -               goto out_revert_creds;
> -       }
> +               if (IS_ERR(new_cred))
> +                       return PTR_ERR(new_cred);

Same thing here.

>
>                 ovl_path_upper(dentry->d_parent, &realparentpath);
> -       realfile = backing_tmpfile_open(&file->f_path, flags, &realparentpath,
> -                                       mode, current_cred());
> +               realfile = backing_tmpfile_open(&file->f_path, flags,
> +                                               &realparentpath, mode,
> +                                               current_cred());

Where do we stand wrt "chars per line" thing?   checkpatch now allows
100(?) so shouldn't we take advantage of that?
