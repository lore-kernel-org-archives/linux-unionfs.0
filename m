Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812944;
	b=PHPK4WQen9GEzalTwtGpmVdPjQSYpU9t+BHoK3NlYKg89NSEs0qcuuLaJrPRPLpRT/Io
	 UQKiHFl2cgcO7SFemEkbpXeMfjs/nxwsIxIryI85/5CeOAYGNu9QFor1MeL2a1Ug3hm5d
	 3RKNKHDe/8fkBC2TdCaZPAGDE8GH2wFmIoooLmlwYCFJHwfs2sWWdmxu9Y2ca2f7qxfFQ
	 rtfE2AqE1KHoB7ITmdjoAzKC4eqqhldCS7tA8Ww9J2KlNW2Nxz1PW4jjA8J6zLGG7/fjg
	 UufVbocVYWe4rSWtUchvhuH2njchqPhDtI8Amnk5ZV2sR9tAhxs+45FofeRA1pDZhfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812944;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=trCudkRlowf15KXENTfDgxDj2b+EYhikc7lQRV8B0y8=;
	b=HTwXdGMZcJ74D77O4gQAvRUlkkI4wY0oygWqg4gVxPGWnM0t/8Br1alvpAuhMfUsQdPS
	 xpph3sHqlRXPwGl0zVqyaX7IBR42TekYtMNNQQw7c7QPzkHpk3teFr7BqGcaFT7JA52Uf
	 UyBEqBEKsUGxP4/9rE3s7BJla08nIaty5caBm/y5DA1bNtvdCRsxJ+QAGxkfRW1sUdkZl
	 w7Y9EAIHIPqpW0BwzsgQJ/jjyUyflg1f/rTQC+QMkTw77bVQBckvZ0iWZFr5yTRYnN1qQ
	 0R+nrtXlg0a8hQ/rPEdi1oFKDhBpTu/x7Z6SMKTGgXkiC3rvRJBq3Zv5kZMo1/99CFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=PC6+0cdo;
	arc=none smtp.remote-ip=209.85.160.176
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360CE606A326
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 17:22:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 360CE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=PC6+0cdo
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5430f70c827so9735591cf.2
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 09:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793812943; x=1794417743; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=trCudkRlowf15KXENTfDgxDj2b+EYhikc7lQRV8B0y8=;
        b=PC6+0cdomG5vROb/kLHJXErM98cBbYg2LDk3QMVqs3tgW+MeYmcAt8D8Lw80tojkt/
         1OXfgL7nlz8UbSznmRrrZCoXiUBswTXbHzZic8VJi5U4V3RBSCsL7vubZNlaxEI2u3D3
         2SbqarhrEhewIDDsNBmEXANEakDeX+DziPUOIuF3Ilwg2ZuDU4IEkXpdCAW9S6N6Nvkr
         Z2hKAy9HzQ0GRHj3ilAQ726MEqZ1+23842XHDu8ChfFw3rtImkuZZoFJkolBWw/D5Sjz
         GZYbhJRfYLuvm/HXLEdM9ZzrKoU3Mj96r3cDMTmZUbPsCimWJQFl+LdmtZH4OC25LSgG
         pbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793812943; x=1794417743;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=trCudkRlowf15KXENTfDgxDj2b+EYhikc7lQRV8B0y8=;
        b=Z7lrcO3auKkFyoyWqAMLqh/D7O6AFOCdd/RHG5KSAPuMRb6UZmjg+nvINLVAXPFBlZ
         1+fH3RF9vzdfDkKFhhx1VZqFVBQl0IS05IW2sJffI+QZR4MhuWNvhcxvwD8Nr3dzz4K4
         +XBUag5yAqKo5vUP8TGZr9GXQNlyDh/YBsNmGeqfBf17RwK6wIraewoatzeqZwP5hO3k
         GkIHQFc43cbPiRxzFW7PWAm77K2Pcg7u+nE2Lpu/mItON378lEfT7caL1jGsgSBSCZnQ
         0w2mEr//HFQOCNhgx/LIvYJFcSPw24pvy2Gmeq7U0zEnuMKMFCYQDD4TzzjAn5sPL5lJ
         cnZg==
X-Forwarded-Encrypted: i=1; AKwUvBwtGEQsv2GUJKqcc8XnoJcVNxhEFKUv/ljuZeNjMaplVHGjrYgXvgUs5w8cPD5TJzE02zfdIk53Lm6jdAK/@vger.kernel.org
X-Gm-Message-State: APuU4Z+g766G8bYQk2ti+MunvVxpSYDwDhTg1mri7lcoWkFKJYvyAPcV
	sqfmDqnd9hsubAu4UIY7DVGxUxLNiEg+Lq285gxfTFjzPZl70aUlcYY65nI1QAyvnlI=
X-Gm-Gg: AYBFou1HQjvgbP3puwdA0DRM1NU+J8a9g0IvMYtSbCiWw4EsIA+pQ2TIAWRq+QYGqN9
	wXKHLznrxx9LY3dK0cFGtn7Jk0mRdDZaTRJ70wU7CdEEJumSu3YQcvmQCyPelZORC/vwtZv+L5L
	iJVQMDMBW0vS30h7yQDnw/oxly7rt2pc2UR0XYRPpHXKfwlzLYhlbWWcAZwuuokIAHn1RiQT5dZ
	ilKt/i4kiacaEtoIMwshDubW1gQXeJNW/mocsQZI7Xx5xSajqiWmfF/PpbKOUxfZxsb80mFzEpb
	tf6KgjPAIsryJpvp7p++ndAEB081g21D12MIqqNeJZgpEjLuFkQF1YaAw8OKHd999i2gWx0fPWd
	iEUw03q6lxRagyfI2q5nlHMUOb86dKV52j+8cBbr5OHKXfGHn8ViwavtrPXbIUE/1DZAvugzo2a
	6uaAI5zxYTPzKqVQZk3RJaU3ctPEFIBal04BXooJ9VgB3hhpgcUrLlOxdp0ZiUcRdX9xVxzFa6i
	WxmbAdM7aa1xnDdw+3UsLWMZgyHASVmK+lah4UOZLRWPv7EfSOsxPNaps2OZq2unhg6Fm5OBZ3H
	Pg6RNW760Tl1rD/8/qNjJ+VeTrTYdpy/88n9w+i2GXtZqA==
X-Received: by 2002:a05:622a:480b:b0:536:7dd:16b3 with SMTP id d75a77b69052e-542b86e118fmr251024031cf.75.1793812942892;
        Wed, 04 Nov 2026 09:22:22 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54b100af507sm29121651cf.6.2026.11.04.09.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 09:22:22 -0800 (PST)
Date: Wed, 04 Nov 2026 17:22:21 +0000
Message-ID: <b9d94891c6bbb0a18176424eadf6ff88.josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>,
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chengguang Xu <charliecgxu@tencent.com>
Subject: Re: [PATCH v2 00/10] ovl: only sync what was written through the
 overlay
In-Reply-To: <CAOQ4uxhWy2aQV6g7VJcV+NDLPTSoGyR4Rag8uvAwN=LWnApaJA@mail.gmail.com>
References: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
 <CAOQ4uxhWy2aQV6g7VJcV+NDLPTSoGyR4Rag8uvAwN=LWnApaJA@mail.gmail.com>
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
Content-Transfer-Encoding: 7bit

On Mon, Nov 2, 2026 at 11:14 AM Amir Goldstein <amir73il@gmail.com> wrote:
> I think this is over engineering.
>
> What is our goal here?
>
> Make overlayfs behave better for the (many) containers use case.
>
> Who in their right mind uses a host filesystem which is not one of the
> big three?

I mean I'm good to say if you use something other than the big three
you're on your own. I built it out this way because I assumed my
attitude of "I only care about 3 file systems" wasn't acceptable, I'm so
happy to find I was wrong.

> Please consider the attached patch.

I put it at the front of the series and dropped the fake inodes and the
hooks in the ovl_do_*() helpers.  It's 8 patches now, yours and v2's 1-6
and 10, and we only track dirty inodes with fsync=relaxed.  I'll send
that as v3 once my tests finish.

> The heuristics do not always get it right, for example, ext4 without
> journal does
> support RENAME_WHITEOUT, but it not safe for fsync=relaxed mode, but
> this is an imaginary scenario that nobody uses and there is config/module/mount
> options to force the legacy fsync=on mode in that case.

This one actually works, as long as we keep doing the last step of
sync_filesystem() as well.  Without a journal ext4 puts all of its
metadata straight into the buffers of the block device, and
->write_inode() does nothing.  So ->sync_fs() isn't enough, but
->sync_fs() + sync_blockdev() is, which is what the last patch does.  I
ran my crash tests on it, whiteouts, index entries and the work
directory all make it to disk.  I added "and write its block device" to
your sentence in overlayfs.rst. Thanks,

Josef
