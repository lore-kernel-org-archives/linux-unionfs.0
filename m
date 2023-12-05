Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="b0PBwmWR"
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C714D42
	for <linux-unionfs@vger.kernel.org>; Tue,  5 Dec 2023 13:25:30 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-67a948922aaso32122516d6.3
        for <linux-unionfs@vger.kernel.org>; Tue, 05 Dec 2023 13:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1701811529; x=1702416329; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JqyDFnCiC9C9iaP1KCSgmfjfaCqCGpifT7WUKn8rGrk=;
        b=b0PBwmWRMGvYvkJoisONmNJ+3T+kkZQqj0m4xMPH8H4VUzuQuonEf/1qKMSlGcFODG
         xJ+T43gtLkRJgKMc86OTz+SAPB3wbKOJ9/Bnygiz1YyRsO1HljWY7NUgPjPS6nKO/0bP
         3UPjHn/vbK2xLjkYQZ4dctCMZCc1gaxE+MMH+xygPjyvPaIipzxqQ3QlLbGsMxlu9ELT
         cNx57Om0Erb6BkOChBEGoOacngBYq9Zv3RzZJR2+cb7YCK1XEzbU2pOM7feYRz4srtJr
         h59hSsZSVVl33yEDvFQi3BIIHFyrzJROvUYLH4T71aQVZlcadBtRPftckPnrtbDCkR7K
         mrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701811529; x=1702416329;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JqyDFnCiC9C9iaP1KCSgmfjfaCqCGpifT7WUKn8rGrk=;
        b=HJ9A5MFULjKXsVydPW5qv8FpqNuHtHYLpnNKR1FwR1lzysACYK0pXYikD9MjpILhAL
         015BK5E2pnh7EtTMshzMFmSv4VlfyNEJzrTWjBIlHjyLGAx18o6WiJNvDJlt9mrBkjQv
         V/LAllPO7ej02O3ONJEhV9NWbyFzfneJVyoDQ2xWsy5xEhifFXZu7YxzMa3UVHx7gh01
         Gp01xj0NuhgTyZJ0ev9XxVbI2WUnwVzFvc3eh+TcmXRu87ah+9Lc5yBwUlTttAGcmgzJ
         aTltdK8Yp4XyZ2kbIqLTmXuRgCtcTM4VafnqiF7SJAhoRgDiXrB1QC/qAnVeg05zjp19
         gbcg==
X-Gm-Message-State: AOJu0YyKDsHau4MdLk2ifduYAhvdCSlqU8i4cT4FJYkX2CNFdF3x9XlW
	Iu37+fETQr3MKcSZrnF3nA24
X-Google-Smtp-Source: AGHT+IHfsAskPVR7qfeDFP1DBUM6Fip1xoU/6JP7KZknQGN9TMVHFQ/nglQSG33mxgd0O6bDYwfI+Q==
X-Received: by 2002:a0c:fccf:0:b0:679:f5c8:2462 with SMTP id i15-20020a0cfccf000000b00679f5c82462mr1507275qvq.14.1701811529555;
        Tue, 05 Dec 2023 13:25:29 -0800 (PST)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id c7-20020a0ce147000000b0067ae01ab283sm315639qvl.36.2023.12.05.13.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 13:25:29 -0800 (PST)
Date: Tue, 05 Dec 2023 16:25:28 -0500
Message-ID: <77e8575a68e862c5c0e64803bf2582b5@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>, Christian Brauner <brauner@kernel.org>, Serge Hallyn <serge@hallyn.com>, Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, audit@vger.kernel.org, linux-unionfs@vger.kernel.org, "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
Subject: Re: [PATCH 14/16] commoncap: remove cap_inode_getsecurity()
References: <20231129-idmap-fscap-refactor-v1-14-da5a26058a5b@kernel.org>
In-Reply-To: <20231129-idmap-fscap-refactor-v1-14-da5a26058a5b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>

On Nov 29, 2023 "Seth Forshee (DigitalOcean)" <sforshee@kernel.org> wrote:
> 
> Reading of fscaps xattrs is now done via vfs_get_fscaps(), so there is
> no longer any need to do it from security_inode_getsecurity(). Remove
> cap_inode_getsecurity() and its associated helpers which are now unused.
> 
> We don't allow reading capabilities xattrs this way anyomre, so remove
> the handler and associated helpers.
> 
> Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> ---
>  include/linux/security.h |   5 +-
>  security/commoncap.c     | 132 -----------------------------------------------
>  2 files changed, 1 insertion(+), 136 deletions(-)

Once again, you should get Serge's ACK on the commoncap.c stuff, but
no objections from a LSM perspective.

Acked-by: Paul Moore <paul@paul-moore.com> (LSM)

--
paul-moore.com
