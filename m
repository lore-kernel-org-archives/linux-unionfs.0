Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD9D2940D
	for <linux-unionfs@vger.kernel.org>; Fri, 25 Jul 2025 08:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753432402; cv=none; b=aHHpmMEVCWYXRSeRDrB77d5moLaXq6YTtP/8LxZxe495T2OmFqnohel2XTUrAmI0PudE9Tdrq5nmhTI4A3aQ8/DloCPaaKk6jtqLwvGh5O6aacgTxLizi9MQKT1k53fvWnlK6/NFRxGu6lPWuoMVCEvfovKhIKm8fFo640ENqmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753432402; c=relaxed/simple;
	bh=4x8Y12s+Ba8R4NwaLHyYbxT+AKxZ3Zn8RG5cdMP5txM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nda/0kMwYj6n/pKYf9cxepvRHe2e14OkEYJkVVu7PtlEAzZLvVkm//sNZucSoMwylTXYRucFNG+r95j9O/MGhCqIZZQgIWV+O6tpw4xGN73v71mJ8zI4kQv6E29L7FlTINiF9GACIXvRvUwmG7SzJTBqD3xHUuYLj1vfWF8Eu88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com; spf=pass smtp.mailfrom=mandelbit.com; dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b=iipTBcp7; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandelbit.com header.i=@mandelbit.com header.b="iipTBcp7"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4560add6cd2so15385505e9.0
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Jul 2025 01:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mandelbit.com; s=google; t=1753432399; x=1754037199; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YRQZ6T3OL6Bhb6D8r2S8e2agKtqZTS60RnUYwgd0KMg=;
        b=iipTBcp7i6zSMx7nzWH3Z2SWO6Km0fNEcYpkINQo5zTqtuCSv9KnwnXvxp9stkCDCM
         2AmfvIGXQ9l9TIjgdLospc0/UqqbIlitbpN5hXAtYfTp//VHFyujV8mmdzcfzbkum19w
         h0jnfdtMn5jyzelRZRnrD4BVkUdYg2DYUaD6tC5Cf2OeFzSKe9YbNIZJFyOzH8+/k47f
         OHTIaKY/jzV0aSg2KApZZYB/+2uIqRXJ+VNJT+cOJkLUP+V3jDP75fznJKwO0S0iF5oM
         I9Tt/SfxkwfRrqK7BwMHt67C9yw10mqdrmZpwPwo0yDNjaVEm4u7YzBcTxnieajgT5oO
         sdkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753432399; x=1754037199;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YRQZ6T3OL6Bhb6D8r2S8e2agKtqZTS60RnUYwgd0KMg=;
        b=BiH/d3QypEvJhuzhECGU7uUWlUlDnjODmKoejICPdm7UsxV3P+asU3qRHv92o6nScv
         fbZaO0jo/GpYnL51vy6Rd7nhg3yBMVxThaFxKgfNIe59n+T6MnKkHgN3Rf3NCRUuWY4m
         lpukaunJ4BVWc5B2rX9vGv8mVJ2UOfzg9e9pHKIXjeOwIDYKr8Z4BDio7xFR8rDApM4Q
         Wc/7A9C8nYRxaDc6EnDw16+ZdbG2ySeFHaZorLwfOGwT/UQul4dpXBxdTZ53YGxRsyxZ
         gZ/MFRTkuGRjztgBkjqmxH384f9XNfL5mTsnfqNVsQ2F3CEwzUIv8Afvw8KTLQPSNciv
         SBEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWuNqzxPjLwQJP0J/vKl6N/wtz9WfZxPIXIkauA1al/8XecrOWUHSxXSrfhos2fmpoxNP/qUbFbPUElT6r@vger.kernel.org
X-Gm-Message-State: AOJu0YyZNub90BDJuYeYkiuKa0QAXNpkrBDKgEEY7t4gKE01bgOctb6g
	TOVUEWx729FBqW5dVcA/UH4DN+Mdj8igqQSyYN3our+i1Irg0+8nHOQg8I0aMMSV5gQ=
X-Gm-Gg: ASbGncu8kWt0jaRSf/E5w1JvWd6F5SJ/jvP+2i9n6MshMa7kqo9LPzAJshYl0ETk4LZ
	2mQzrjlEog/qQTDu3OSIgXGAmN67YRISfirjaG0VG6LkcYUTDf9humhmgYB16MmZI+IrzrGdsKf
	NgjonRCtGS4OF9DXIRZv6Ebpnh1NMgfP7NYbYYA/KVNVAz07ECs7jw0SDpXDwhjiCvKPsoINLoF
	cr7ERtZlpjACcLsCNqYeUu7GJicNsQqAHFlVVxnll3bIY+sv3iNYjpNoSPLHmZnJ9vMrHC7hu2q
	E6ZyLKOrHQHi6RFIlnZnAWDdMqbp/l7ZWgMG1Z08BXKKptbqNwF0lti3pnQdUzXGEMv31fwHtBe
	674g4FcDSx2dAaVDCZO58gATfSI7VuiWOpvfGvjM2t1eSsbPnRiX90dzkOrSKlEg=
X-Google-Smtp-Source: AGHT+IHwCsCc+XG8OEpTav8aCM2jt4FsZycByziGTS5OJ99kaZBVhzyfai2SpEFBnJsf8+SgByEwnA==
X-Received: by 2002:a05:600c:4513:b0:439:4b23:9e8e with SMTP id 5b1f17b1804b1-4587554fc76mr11131355e9.3.1753432399380;
        Fri, 25 Jul 2025 01:33:19 -0700 (PDT)
Received: from ?IPV6:2001:67c:2fbc:1:967e:e053:f2f0:72bd? ([2001:67c:2fbc:1:967e:e053:f2f0:72bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcad0f1sm4489953f8f.41.2025.07.25.01.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 01:33:18 -0700 (PDT)
Message-ID: <542b0862-7f66-47ef-9ced-c66719842710@mandelbit.com>
Date: Fri, 25 Jul 2025 10:33:18 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: properly print correct variable
To: NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org
References: <20250721203821.7812-1-antonio@mandelbit.com>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Autocrypt: addr=antonio@mandelbit.com; keydata=
 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
Organization: Mandelbit SRL
In-Reply-To: <20250721203821.7812-1-antonio@mandelbit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 21/07/2025 22:38, Antonio Quartulli wrote:
> In case of ovl_lookup_temp() failure, we currently print `err`
> which is actually not initialized at all.
> 
> Instead, properly print PTR_ERR(whiteout) which is where the
> actual error really is.
> 
> Address-Coverity-ID: 1647983 ("Uninitialized variables  (UNINIT)")
> Fixes: 8afa0a7367138 ("ovl: narrow locking in ovl_whiteout()")
> Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
> ---
>   fs/overlayfs/dir.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 30619777f0f6..70b8687dc45e 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -117,8 +117,9 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
>   		if (!IS_ERR(whiteout))
>   			return whiteout;
>   		if (PTR_ERR(whiteout) != -EMLINK) {
> -			pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nlink=%u, err=%i)\n",
> -				ofs->whiteout->d_inode->i_nlink, err);
> +			pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nlink=%u, err=%lu)\n",

while re-reading this patch, I realized that the format string for 
PTR_ERR(..) was supposed to be %ld, not %lu...

Sorry about that :(

Neil should I send yet another patch or maybe this can be sneaked into 
another change you are about to send?

Regards,

> +				ofs->whiteout->d_inode->i_nlink,
> +				PTR_ERR(whiteout));
>   			ofs->no_shared_whiteout = true;
>   		}
>   	}

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

