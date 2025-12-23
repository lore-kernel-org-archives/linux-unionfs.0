Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093DC2E7F1E
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 05:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468154; cv=none; b=K2tCUXTqLxzbI0xSbeisboSoRw8UKwxNArTUVPVWJnGoXpzhaJAXu6jscDR0QrFTvHEBXWnPngpEIP275Ma9KcDBA99swSV5gEbZMHEFogTlI7LrDCSU94c2BKYnHns5aBz67sAAD8jiTJIpCFuy6z/SzaHYrY0Jrouvv/ohhIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468154; c=relaxed/simple;
	bh=g9Bt2s+UFC+DeXi/131tDLXltXct0EalOx5ApUtrNkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UgSR4CnKJv0/PF/kvzRnYvx5holfAHmCXbZjKPn96GmJPPyp4d1C+R2BOocqoix11GF5YVnp6CGTIVWeyKyosJxsoaMfKBizR5KO4QdzrcbMgerfLsZmgSYWduCOFRVg9naZO7YY6vC6v29DefkwaANRii6KSba9jJ0EJRcsaBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxX3T1Ps; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxX3T1Ps"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-11beb0a7bd6so7845097c88.1
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Dec 2025 21:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468152; x=1767072952; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1VDWjicrLkuqVcwGv9d1sh+ocm1fa0mGizT1YHR+Z6c=;
        b=LxX3T1PsbL7A9toWeCRP1ZiEISt/so3/Ge3jUHQW4vV4bDI+CFNh2mgvpyMRmaKHoT
         /MVJPZzIUDwB/OoYv1aOhJKvrOm2AivnEB8xW6vyl+8+1t7pR6MlWzwtRfU/GfflqC6K
         3JQu8w0MC9/CxAeX4efBrU98BIUAeM6jx8wPEXyWQR3NDflVWRIrWEIxqQR4++JYkCHY
         bFEz1B+WB9h9jFH2Xqa8kzgS5ZTgD86P5uMkVxwxMjciEze4VsRaDj13pFlXKT13kVUf
         kH4LjKRVTROQaXbg91AnL4dtGRfgA1kC1ZeJH3Do0F3CuIrtVgeWGDs/NQy0SWkny28V
         x0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468152; x=1767072952;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1VDWjicrLkuqVcwGv9d1sh+ocm1fa0mGizT1YHR+Z6c=;
        b=m64lxDRPH6DNX833pj5CmqgRnIXroopkEciclfmaEBZVFw2Su/WkVy+eAvz0sVaxc9
         loIZ3VQ634qVM2t9KyNMqIhCpebU5LJPifHGMxpona6uZ+8RPZfSptbtwvPNkBAgqupl
         S/Qxzc/cIGHUhG8AS5Jl436xtjB3j032/v6e2kTs3XP4cetwmpPtV+EU9kPEii9CeIid
         GtbpMZ32gWy8WaqNaQYofLDL1a8pQ+o0h9OMaxKhNijnvmqYfqnKX17jikoE9F/FF8ZE
         Z+xc6iw6xia2dsBxk+ckaBG8/whBRaa9hvhEvTZJzSWi0y/eLDskOvQbs14lnMD0p571
         8JuA==
X-Forwarded-Encrypted: i=1; AJvYcCX7WKeMQxrsnhVfxtxVOqTFt2SLjIk1sQ+nR9v895YpNqmRLYmWKaGhhafpORrLW2zjtB3dWkJ+NafHLgME@vger.kernel.org
X-Gm-Message-State: AOJu0YxkO0NUh1RpJZmdsjRHBOaOPG8RIC+Jow5/IJalasFJ8jpuVVnw
	+SNsA2mYDuGcamuY7jVt8covfcN2/8Ajgy+QGWpxXh9DuBUM6EOIAYeq
X-Gm-Gg: AY/fxX72t5v20CmI7ZItTVTc3XgKEdD2OL476txkD7Y4rLN0IoDR9pjVbrMZjWUyVve
	pZGQiFNKAYvJUuE6yaELw5ZI4ICy3xaO0UiUJnLYXXsTKxZmO5xJSrzdKj0Y81SvhiK/n6qn+q0
	zjMwOJr+5UsXDUTbvs5bsG5sac8CpRcHhZKEF7lFYY7fKktP6WAOfY9Aazez6E9ZBJl2tdfKr9v
	vc5fVhp09Tl3t0Z3N8+5DFPbtVbwmtu8sQUikJkt1DYwEj2G8739dnkzVk/R7YhJfeSb1ZV4HN7
	cDzJXDHh/NAM6qM2s10D8x3vI6360wCKREJZjw79oh9wKhzIwLgwwkuVktOW46wQJKiAqqaGdZ2
	HabdZu3tci2kJTpnZ/n16t4f9Vo0YOGJlrqrhxa4rwRvQJ94FKjaCqn0/gs2cxs0VsLTAKEA0NG
	H9JPNkQyG6QrlxAtApjXdIc4vdWfyXkhborJg51TeqhfNH+K8woKWpX09JFhZTBpjL
X-Google-Smtp-Source: AGHT+IFgD3SNwd/4TCZfokt7AW5oqjEJYNTcZgO21z1zxvgYYO/3rgL7QNl7uSOUpz7Nh4qCGFV22A==
X-Received: by 2002:a05:7022:eacd:b0:11a:4ffb:984f with SMTP id a92af1059eb24-12171a85250mr15323051c88.11.1766468151780;
        Mon, 22 Dec 2025 21:35:51 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121725548b5sm54725089c88.17.2025.12.22.21.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:35:51 -0800 (PST)
Message-ID: <6f297260-3c99-4330-92ab-deeb1fc5d8f7@gmail.com>
Date: Mon, 22 Dec 2025 21:35:50 -0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] fs: delay the actual timestamp updates in
 inode_update_timestamps
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
 <20251223003756.409543-5-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Perform the actual updates of the inode timestamp at the very end of
> inode_update_timestamps after finishing all checks.  This prepares for
> adding non-blocking timestamp updates where we might bail out instead of
> performing this updates if the update would block.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


