Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7354512CDAE
	for <linux-unionfs@vger.kernel.org>; Tue, 19 Nov 2024 09:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732007153; cv=none; b=UAgR65M5nP3evl7N8/+ZU9MzK7cD5OFrIbIy/i+KS4wk2e0iVpycYFGVOW7mxBZWkftIYlOXvZ9P1olH3VeIU1hura+AjzLOOtA1dAInStyj49ZaMxZoMf0jnI4yP1A6xg00brCVGcPU2PJRVuvaqCUw1VxLrdumVY+8Sb0ZbjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732007153; c=relaxed/simple;
	bh=N2alj4BmRrIOvTic6YYotKnQgR6KFlCIUzkiE42YH+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aCl9j0T7ge86IaexwtxF29edbTwUIcI31AGV7/gJ0hvaM8D/QaviV7hI9Mn80wc//7oDt9TJ4JXlogtK5/XocPJfVE+kIYlWUyeQ6+gX2sw9D52hKoAYxoAzQs5EYcL86r0iFcATKyxjeE8N+O+d1p1pOyQRo6WFZtYBBQ36WGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=KGx2XdLK; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="KGx2XdLK"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-460af1a1154so26369681cf.0
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Nov 2024 01:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1732007149; x=1732611949; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+TcJ6YrE5I28mqgFyB+jLz4liPKaJparkuuvli/dXqk=;
        b=KGx2XdLKviDXUVQA5WQot2vt4Jy6M09CdydVulgETgAzdtCbTSLQFpYLOYNHABH6uS
         j37b5v5OULKzRGMOX5iGdAXoqRkStZIziy0Nd9w4lqgM7Z1KfiQs55TGaHK01Sg5MFT0
         39PVjtr14US5XUFwwzRetxXi/g6BGQS/i5Cbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732007149; x=1732611949;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+TcJ6YrE5I28mqgFyB+jLz4liPKaJparkuuvli/dXqk=;
        b=XKAcwbywzB3OhTZ559k77GDf4Bp51sQu/bXIun9L8lRZQXQun6KzZWzxra4xk6hSYl
         ia9LEJmDhgvT5peFgBdNodRxQAUVGt839Fyeq+bb1tNw/m8XYbnNwgAJkibowdM7t587
         gBN/fHSeyYy73HxH8lNrUMNZWIAfbJOlAq30n0AbyeIg0wEFDWgGquBHkZg5oSBZHsFR
         PNmdYfnx4PBmNaeSUM9qrDidJET1Uk8xItf6QUzghrRs0s8LXPz32WHDbalDJbsNiI6z
         0mwXjn9hxLUeRZNyIdaCSNtHp96lerNYkgmBCi65H6oQRZlIW42sp+TEuoz5EvURISfY
         4HCA==
X-Forwarded-Encrypted: i=1; AJvYcCVU1jpBqkrkbLcWdanJLhJHh3yBTpQNI6Fr5/3yXR7Wz6zdPNevmORAnfIyYx++ThItictl5Qzi6ScFRRgc@vger.kernel.org
X-Gm-Message-State: AOJu0YxLolWUpk4XGow/Q8bOvBXte3kyDrT+t6lAv8Fa2w1232a7JhPV
	+sbv0QIJ9/YsQCD0B2N+bT3Cg5QSwuiXCC1LOQVLihQH1nfho8cKzVColtA5NDqIuZTDUps/Vtu
	RL97ltgB0Uw/Eq3MkFttfehDxtZi7DfmMxMDWbw==
X-Google-Smtp-Source: AGHT+IEMAq5emnll1nkE8jbEYFWUcdvqCUSQWuUzb10IHw9jaCmEC5N3mlyGo0TdfGO92TzodaMEy2DH3K9iD6UPON8=
X-Received: by 2002:ac8:5206:0:b0:463:4b88:caa7 with SMTP id
 d75a77b69052e-463773c8f21mr112410241cf.54.1732007149263; Tue, 19 Nov 2024
 01:05:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118141703.28510-1-kovalev@altlinux.org> <CAOQ4uxjxXHX4j=4PbUFrgDoDYEZ1jkjD1EAFNxf1at44t--gHg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjxXHX4j=4PbUFrgDoDYEZ1jkjD1EAFNxf1at44t--gHg@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 19 Nov 2024 10:05:37 +0100
Message-ID: <CAJfpegvx-oS9XGuwpJx=Xe28_jzWx5eRo1y900_ZzWY+=gGzUg@mail.gmail.com>
Subject: Re: [PATCH] ovl: Add check for missing lookup operation on inode
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vasiliy Kovalev <kovalev@altlinux.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 18 Nov 2024 at 19:54, Amir Goldstein <amir73il@gmail.com> wrote:

> Can you analyse what went wrong with the reproducer?
> How did we get to a state where lowerstack of parent
> has a dentry which is !d_can_lookup?

Theoretically we could still get a an S_ISDIR inode, because
ovl_get_inode() doesn't look at the is_dir value that lookup found.
I.e. lookup thinks it found a non-dir, but iget will create a dir
because of the backing inode's type.

AFAICS this can only happen if i_op->lookup is not set on S_ISDIR for
the backing inode, which shouldn't happen on normal filesystems.
Reproducer seems to use bfs, which *should* be normal, and bfs_iget
certainly doesn't do anything weird in that case, so I still don't
understand what is happening.

In any case something like the following should filter out such weirdness:

 bool ovl_dentry_weird(struct dentry *dentry)
 {
+       if (!d_can_lookup(dentry) && !d_is_file(dentry) &&
!d_is_symlink(dentry))
+               return true;
+
        return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |

Thanks,
Miklos
