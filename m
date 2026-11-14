Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794658799;
	b=Tt5NxKOF2hgR4fXwcCXpVa0KhZpybkf0u7iOoHX3D2dTZfDM+0C4aLloejsVe4iFh+ed
	 MA3oi6Lx6SRAvs7Lco9fWnoDMYXWeOp1dTi2PtbATY+NzZgLYprMCvf8bxnl/RM6p1Uk+
	 8eae+GGaa90RUjna2csZ1kTIuKJ0iwccnamOQ1hQD/+NzgmzyrCTeyyTtg+ZuJoJdPALs
	 +upfPsATI5TA2hSSAIvCRkful5sv3LWkRFYN/b511wcPCSZfbfw4thUKbLsBv+0UNgrJ8
	 UY06pPk+0OYRU/s/bEDLbqBDx1HdjqM1FLFVxZw7zQ7AG8rcKRkQkA8iH7c44KSzsgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794658799;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=nkM3J4QAu8kIsGHpB1EKb0NRF0JxtY2T/gqGpQ/nt0Q=;
	b=Ap/5/jgcL757KTzcWJIMkdejifgvxcRUvRpOoAaiOMMRj+U4oLXhJGqDnm4SoiHe8BGh
	 pn5HpzGY/Onn/0Ds6/eNOakEPXqUEObsHF5xdgtyI72Wpu3SgUAqucn9RtQaJgcFgrsjm
	 b2D1TVvxbU3cNQW+YJsB3Y7rkI+XjslXW8DHkokT7zZEhbaHIXpGZIr+m6veJiW/fjKhs
	 H1suTxNGA1uW6in9HqWpkLMazeukqfkkw+q+DT0Kh2rBHQAuJy0S4BlSoOfHLhpBvZt3X
	 lGTYLfxYPUvA3YPbqBLattLIBrTFh78XYr0FbxLRJY3gUd07caGdcX7ApphlSQTTIjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zvg2B30u;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA34606A337
	for <linux-unionfs@vger.kernel.org>; Sat, 14 Nov 2026 12:19:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DA34606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zvg2B30u
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c169ae1cb26so387165966b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Nov 2026 04:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794658797; x=1795263597; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nkM3J4QAu8kIsGHpB1EKb0NRF0JxtY2T/gqGpQ/nt0Q=;
        b=Zvg2B30uBzOFFo54OpfHCzqSK6TOyxTRmwNZV7t2nfrBwunaCrRH+5tI09/jIosXZS
         GdYk6iMfyO0nJ3moVzjaSKnXCCWxcV1Ye+R/4YjiwdwGG8ofIv4PWH24MjP/VV4CkNiq
         nSM7j6UNEdEDdNWpjUjn43q9YL/wt1IFltOrsPhL2VYrn8g/yyR7Uz6PFelA0j1tolIT
         QTqiv37OCVMy+5oEwlNBsw2cKiejzgZGAC7AZW2QPAu9cR2dMcfIteYf8vq02JyCIN53
         /PYiFz/vA+fp7KPo0fCiRfu55fCeLd5qLFIcUMGbAUVH1mkivaDzQTprXnn5n1PDT9pn
         6ZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794658797; x=1795263597;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nkM3J4QAu8kIsGHpB1EKb0NRF0JxtY2T/gqGpQ/nt0Q=;
        b=wNngyMgdqpM1ORDblh0q9UJB4n262ut25xmHDR8w88xXxjsMJ9guqEcMIUcwSXgAiD
         ZbwLo8h4DmudY4x9AQlM1481un9PxAImKb3kHs8Xe3ziJnm+9CO50G2ycwl4/Z0Ja+g2
         VRGcb0Ui/Met3xvmiCnu7Pj4RNzwSLIWfCDu2uwGppKfog2CgsR5vQBqBnA6z2vxS2gb
         eQd0FgyUjzmzKgJm6LMCZ79GU4R6OMMRJ3c46Q+gDB4b+q4C+eMfbl5Yo4krMZcQRAkr
         qokETsY22ua9hBeOpsiKpMg9CvyTdd9s5BJzyab4gUG9qt1R2VMT9Z5S3UvMv8L0ShAV
         Iz0w==
X-Forwarded-Encrypted: i=1; AL+hErFk3LXsC0EO6epuTZpSZYWs1fpVNe8HrJqteA9XC6/hMFzs4rSzjUe0SkRG8E/I+6UqxjClgEPubRBpz6Nv@vger.kernel.org
X-Gm-Message-State: APuU4Z8yNJpJ/x0jLEoQDms7oVCuA0GD/g/hvm3C7J3GLfQg1o41aFa3
	ia6w3DWjpN6tRxNwxnTrtgY/j/WV9DoZRV1EazibQZqgdJe4H3NFpEhy
X-Gm-Gg: AYBFou0D9DGoLFYZtoX0s0VGH9B2tgD2DKvUmmyR58nzMnv3OVqJJ6AZnmPUycf0mNq
	WOTiIWSqvQ/gblyaaEjRd/FxpB6NpHMzjwnX+/tC9OVRdmzJpw67EsV/Y/NyyqgPUUu/CR8MKqH
	FGPQjtciVX/T/4akgcrH1t2b+75iCYdRiTvL0BaJb58E0/iEeoi+mbxAKbpWjujRpHcml0YAg2s
	SvnzJhv49CfDyLmSuguT50zh20KOXLGEauW67dsMkmA0tCbQC8A7IkK39+xsn9ekWN7pCykzV7i
	uQrvTnxiR8QHexcW/hRddDDzStF/oq+aMTr+0PfPsHxJGTWIY5MYotAlxi56XFX+fAetpfIooXf
	rKwOmLNJGbI94WzpgdTMXoi6sTHs7K8Ofhes3+xy0r59h7zHpWILmjS61Ttfte70ae7jVbjJ+Xk
	LstFn0UNxuuVML4PgeaomtINgsmaO0bjbZ1uhxneaEL9afCyn5Xyybsv/13LGeKYhmQM476zAnJ
	3Ak45tO1FzoH+ff7Bb8IMI1ngYb+c73nf9I+QzmJ6p6FebwuThvj3eBUGh8+fjxRBodQh9/OMnk
	eWZkU9RhmbNnoNDl4aTy9lCTxQ/0c/MpZ5PW6YOGz+2HAql+s27t7tV+1YJ2gtnpVsiBzRHol08
	IR3T30fdfYBfs
X-Received: by 2002:a17:906:1001:10b0:c41:4512:560d with SMTP id a640c23a62f3a-c5096387b02mr309942166b.16.1794658797424;
        Sat, 14 Nov 2026 04:19:57 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b5ac2asm211518966b.55.2026.11.14.04.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 04:19:56 -0800 (PST)
Date: Sat, 14 Nov 2026 13:19:56 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	bpf@vger.kernel.org, linux-nfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 10/12] ovl: take freeze protection when storing the uuid
Message-ID: <avhR7DbNbVDCyPDO@amir-ThinkPad-T480>
References: <20261114-work-fs-frozen_writes-v1-0-f5ae61c898b1@kernel.org>
 <20261114-work-fs-frozen_writes-v1-10-f5ae61c898b1@kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114-work-fs-frozen_writes-v1-10-f5ae61c898b1@kernel.org>

On Sat, Nov 14, 2026 at 11:47:17AM +0100, Christian Brauner wrote:
> ovl_init_uuid_xattr() stores the persistent uuid in an xattr on the
> upper root. That happens after ovl_make_workdir() dropped its write
> access to the upper mount and before ovl_get_indexdir() takes it
> again. So a freeze of the upper filesystem that lands in between lets
> the mount modify a frozen filesystem.
> 
> Take write access to the upper mount around the xattr update.
> 
> Fixes: d9544c1b0d9e ("ovl: store persistent uuid/fsid with uuid=on")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

> ---
>  fs/overlayfs/util.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 521717209b2e4..67aa7b71e9c83 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -829,8 +829,12 @@ bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
>  
>  	/* Try to store persistent uuid */
>  	set = true;
> -	res = ovl_setxattr(ofs, upperpath->dentry, OVL_XATTR_UUID, uuid.b,
> -			   UUID_SIZE);
> +	res = mnt_want_write(ovl_upper_mnt(ofs));
> +	if (!res) {
> +		res = ovl_setxattr(ofs, upperpath->dentry, OVL_XATTR_UUID,
> +				   uuid.b, UUID_SIZE);
> +		mnt_drop_write(ovl_upper_mnt(ofs));
> +	}
>  	if (res)
>  		goto fail;
>  
> 
> -- 
> 2.53.0
> 

