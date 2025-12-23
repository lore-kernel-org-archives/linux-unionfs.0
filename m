Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203332E54BB
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 05:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468173; cv=none; b=sSkf7DKEDcgqpXJUI+D/pXRsYZoSIuUV0uOyRwe/Ulri9TE03oVsXyF2e8cdOBPSpSyUNPR6hgr7+PfwW1hSr9cBoTaBhC0T/CwuFgf++ZJ3kmurDyfvUvo8iFDtmZyhgS1j0voVsnHxQsCSiKQJO9lxI9bxFaa3kuI9RM6vQe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468173; c=relaxed/simple;
	bh=lW+UmIWRSVZ7zpivjjDN2RAk8y2uECMzZoBmWD3afKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kUf4udel5OrlGEjC5P7uZi7JZGGg8OY5LE65ZOEswEtDBrYVyhRpLx9QMTrzlclBIpsK54iqah76Tsa2AhkgFlui0c5vcejDR93/FixKAWsTpAxQw32GCk3PpJ8UPKjU3gVVX9eLkZAF5K4itYQOvTV7Uf1ek2Udr/aJpfwwqqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ung45Q84; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ung45Q84"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-34c3259da34so4594268a91.2
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Dec 2025 21:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468169; x=1767072969; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lW+UmIWRSVZ7zpivjjDN2RAk8y2uECMzZoBmWD3afKc=;
        b=Ung45Q84NKJpgXUpj6V9c/ed39FtjE6rEaUqQWkJJFS7fjSzXwil3mKYAY6k0P8R9Z
         ddtgTfoZNL09/7vdeIMFC9JYApmDKSVclj15wMPBUSYzvYzI2V1K6y3+4OrBFi1YYL2i
         Ygo61aSI7PTM3LrIlLqoQR3YIwD47T+aDfeoHcsd1atowsBYoyrx6dnbVIVfEB/MalJF
         2NuWCA0r1bN8toEVguQoOSvqibnOTY8FjNDSkJ/sdULSEVFDzpcjyqioyPm4wEmXqrj1
         ilE8f7MJVCDOQnn9/KIYfxwD2zQKhMHjA+B/jiX/srEFwN0w8KKug3A4yAIpvlDCg4c+
         GzLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468169; x=1767072969;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lW+UmIWRSVZ7zpivjjDN2RAk8y2uECMzZoBmWD3afKc=;
        b=P8K9iOPJf+kuVuIokHMyVG2PRD/ofH4t8xVdyo5SZYyXOxuHDXOQobFTX/0dlZRaUE
         Ip7ponefUxonC5HDDLcXqAB4Qv2Po5gqJjpeSeCgJcgbqcTz8ugRemgdXXTPGnGxR4Aw
         9Sekb2V6dIK84RLhZjTZcNZG0uhr7D+0Xakn9oBB78MZ0jB925Kr/XPVHcx3lW101xi7
         lE7u3awYdG2a3+VVc5hjYn5HgfYuWyzk0I3S2zxZncrOpqUSYeB16xSuYCJhtrVMbr0i
         k+51OartCUqGmbsCUZ2qlsiL0sEvZ1d5tkivhohaIRPkZkQd/BrxKb6pbqXMDRxT584K
         HmvA==
X-Forwarded-Encrypted: i=1; AJvYcCW2ofGDeFjEqT/rUpEzyl1HLF88EJxANqeurTn3LYNc7JzIPs0FQi7zXO5n9k05QLHRKdVp2d9h7e00lkx3@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Y/qktBLB4V1Do2N2E5TW3YgsBK9nlEAT5L7F3xL9tiX19m3e
	KR0pxvF9AhnySQm357GUuyPmE53l5QZh3zHoR53OxAS/fE2wWhtEJu56GiVZfg==
X-Gm-Gg: AY/fxX4LJCHiD4erp+2CjfZk/t74ZvBbJKVc5awM3ODGPyqNKD6fETPabfK4f8W4cUw
	l5knNEK4d/ckOV8zpldnotq7bTPsPaxLAOvY8e8sECW1UiXiFyzcuB7osSGJVmLE37EVrercf2P
	Kcwt9Liz71awSK13r+mvXgR+pfH2f4+eoieWxUc16OcXk4TOhJN7lnFe3NCrYbdKpGPHnPoEp3G
	BWphdkY/QpbWlmhCjci/im38SzLluq/mcGCuz+v2/O/tD2TpSgy66/QPme1USjxgB93J1lcE2lj
	GMM3Zk78PKMJJJ7BgM3HPuaemh9gU4tVxcyFWHhGjl7BpJqOYSORas827WlUep+bQK6ujO4Iwm8
	xpbN4w8gH/3xGBhxHHJa3U3xoyeae4/sPElfws61dBow7uEUjuDAW9TzUeb9wdBNDbMmZNmELCA
	5ItuaxVZPouaUihdGJBqPAhB5yyzQOKXq0I0nkoKIykx1LMIsGXFfF5YAAtMJkCvvZ
X-Google-Smtp-Source: AGHT+IH379xsDZ0d7vjKdC6ERRiENfgRNsDKq+A1tK8cXdwsmB2ywvOol5d1N83fquxU7SkCjjJrLg==
X-Received: by 2002:a05:7022:3b8a:b0:11b:79f1:850 with SMTP id a92af1059eb24-121722b7f23mr14589383c88.14.1766468169469;
        Mon, 22 Dec 2025 21:36:09 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254ce49sm52556580c88.15.2025.12.22.21.36.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:36:09 -0800 (PST)
Message-ID: <e2d34cef-c0f4-4f27-91a0-439f85ed26b5@gmail.com>
Date: Mon, 22 Dec 2025 21:36:08 -0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] fs: return I_DIRTY_* and allow error returns from
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
 <20251223003756.409543-6-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Change the inode_update_timestamps calling convention, so that instead
> of returning the updated flags that are only needed to calculate the
> I_DIRTY_* flags, return the I_DIRTY_* flags diretly in an argument, and
> reserve the return value to return an error code, which will be needed to
> support non-blocking timestamp updates.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


