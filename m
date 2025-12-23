Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D242B2F39B9
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 05:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766467988; cv=none; b=gq7vgMgmTYbeduwZtYseQI1iR19znWA+PHh1S0taGys0AtJ+4O+2FUHxuOt4m2Br6XIYdHh4Jy+OH2MIYxZeuDoit2P8uk9iMFf4ogSW4W9pM7mYSQwUaof79Xhx3B3tsip9KPE/7sGVVkSDokAJlkSSVZpKgaDVgeF0WzYU7qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766467988; c=relaxed/simple;
	bh=NqkuKEROb/OmRVYRZgeOKw/Kls8Un9PKgqEiKcwkGnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BAtkIP0l8dZoRjDcwluDTBZUg7UmJ//Y9OUWj8sKddt+gIlnRrK+HPEJIMwR3XqU2pZDjDXZrAwXX0m3KcjvfkjEv7CI81ZkfedGlMEBCAeHhdXHw5EKtFGSYOaW+L8CK2HQ6466ZKGKl3QAbAeOfUETM2VFU4cAUAF3eRYDA/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YRS6qc7F; arc=none smtp.client-ip=209.85.215.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRS6qc7F"
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-bc29d64b39dso2482143a12.3
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Dec 2025 21:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766467986; x=1767072786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NqkuKEROb/OmRVYRZgeOKw/Kls8Un9PKgqEiKcwkGnk=;
        b=YRS6qc7FN4EtduWa68ZXt023TSQiTMXdK7qVlD+eqY53wkWAc89L+baCoLPtatoQNV
         nRV1kqExU4x0Kq/7nLf23qk+jbHPJl1ohW+d6khZJaUUSHKu7UEyHFcuAq3mVyZfVs2E
         mTs3xHvhMuxCjBsNRAzGXzVyQIm1hFrGsZkIVSNA3tnwpvXfk5MxMCrp1htANa4luD++
         f1I0ejIHnRULvDlp6uuawM2q3dtIwL6o3ClXqX/3lAzNiyqtoHm6/1AckOVeDCqzznAA
         cvLnp8ljOlrbS/ahjo6lewbqz/tmL6Gf/oJ28nvKtLYo97aUsLsSQU7wgUM6LnBxyHtH
         UOVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766467986; x=1767072786;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NqkuKEROb/OmRVYRZgeOKw/Kls8Un9PKgqEiKcwkGnk=;
        b=cvclvwsU9no4Vg/+eFHGOsKmSe7ZKAazKQNezjunJyNqNHZjSH3BoSMXUvB/UEn5Aw
         Ux7UHnFa3Dhy9y0rzW2rh16MTQb5IyciIGt2qJT1yRES1ulYoob3DhZgIA5XDaHUSnnh
         z5qU0anSdEiL/BjVoEHkfdFN/SR0luDdVagSKg4JiOhpeGrvGuYgLZm7R20/IGS3NYqf
         C3m7U0Rs8uImtNpEpHQJGJTTP9wrLuRJuvX9c3uPJ8eCT4RP+o+wx9/1FsCa6og7Z1aW
         jS/KAnZHJnfd33JOKs91gO4aa6gIYwH0vok1x5rXL6OxojY0WgDqYvvwZD17Xi4pqpGa
         tPxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSCusjEXjmWLfZUgIU7LnkocRcvFf/3BiF5ECFEic67D4DASdzqGBIkXs6/qKypRxSeVdO9VV5ggMZu5x3@vger.kernel.org
X-Gm-Message-State: AOJu0YwMAFEBU+SkNzQsgxO7Zv/6Pf3QAYd3SCEAwWHUKbSaQ9pGkSAr
	xl1LpReEWXHFWUcDCKiazBlbbw0PQ1qfF5vRC2DAtUBNJJT+kttqWHK6
X-Gm-Gg: AY/fxX6UdTjUVv1AZnKUiG+zCIn8oHqNgTgkVkJ+LGtRvAKEMubrMQNDNx2Os1KnHDR
	yrt0/DF33yEWd3/VcKSaiCYBS58K3aJjWDOgVjnBsudwl/7gnUIJELTcw7LwvH5YtOSpKlOi7wd
	6OGhr0LJLnzeUOZYRhfb/WVLOjOEtL++plW6uIPZoK3mzaq+70sqsbzISNWpHimrvHAuAlhFEdo
	qyVvD7Bn013mkvx17HlKQ+2vWdpITPP/5hJ5ZR4iG3QPU2T51liOA5rPzXpwmWVlZHECfoFBvcy
	YoITli5uqcks2SFW/IYRkNl5C4N0svX5mR/SgrJzR48dv1JuJxBElcodrFYkXqRnHSgoUaR4U0a
	P5BsUIZ5CVTj1+zN7Xd3X9WormSliOH2xSS7fmVgRpcpwMXi/McrU86+FCTZg7FsmyvR7SCnyki
	Ts6w5U9DQtnivPPbyxfPelI0XBbbrdqjwUpP+wxZGfnWbEjzK8Ib03YArxjjm1LJ7j
X-Google-Smtp-Source: AGHT+IG5Qf4dCPxqVYyhhZiZ2cPZHWZcc5Jl8Dom3Sf+VbFYEbzUaslYB9RlXBdrrGXOm7O8E9bw2A==
X-Received: by 2002:a05:7301:1a12:b0:2a4:3593:ddd6 with SMTP id 5a478bee46e88-2b05ebb6038mr11158060eec.3.1766467986000;
        Mon, 22 Dec 2025 21:33:06 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217243bbe3sm54002618c88.0.2025.12.22.21.33.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:33:05 -0800 (PST)
Message-ID: <12bb96b6-1e2e-4f53-b4ea-1fae2500aa21@gmail.com>
Date: Mon, 22 Dec 2025 21:33:04 -0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] fs: exit early in generic_update_time when there is
 no work
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>,
 Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
 io-uring@vger.kernel.org, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20251223003756.409543-1-hch@lst.de>
 <20251223003756.409543-4-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Exit early if no attributes are to be updated, to avoid a spurious call
> to __mark_inode_dirty which can turn into a fairly expensive no-op due to
> the extra checks and locking.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jan Kara<jack@suse.cz>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


