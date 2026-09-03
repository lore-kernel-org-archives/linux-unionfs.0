Received: from mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603D346D09E
	for <linux-unionfs@vger.kernel.org>; Thu,  3 Sep 2026 09:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788426715; cv=none; b=Tw46dyzmH4qDsPsFh8wq1WQOYfEWU/9PUqBenfv6jT8PiKEu9BOSDPpgyNIGqEOvR1t7qYXPMsgqdU50vNmey2Ws3vVvll0UxYhx1k42wJCfKG+05V8RWx6/DBVS4yi7IgCraJeCzi/jk66gyjPN3XisbrUsUNlKyo+cRphglyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788426715; c=relaxed/simple;
	bh=CgN0w/eudyXQY8rZE9Aqh7i7PEtWKIBv4uyTbWxNO1Y=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SizJ3T7cD3EDHv1D7mMPkHSD7G09WJNV1xn7EXOZCp9oivS+y2YWBZ/VQ5bqT2YuS4fcSbPsbC7fK8Uj6gf6unY5T6My/CDE/Lf+3B+41R9L14MwkLq/FfCW1SG0g5wTNwMRLwteRpg7qNOpF+/4EFjF40VOJ6w7YGbPqByJgz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U0YZPEd5; arc=none smtp.client-ip=95.215.58.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U0YZPEd5"
X-Envelope-To: linux-unionfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=CgN0w/eudyXQY8rZE9Aqh7i7PEtWKIBv4uyTbWxNO1Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788426711; v=1; x=1789031511;
 b=U0YZPEd59LOhBnogDT2ZWC1ubJL2uoJtbrC2Zalq5Nd11i76bq5xsgpGGuuW9/0ZUpC+2Jvk
 tBu2UcxxkRS+NxNpANcb4Wg7h7D6Tn3UsRfpn3uDFyvUU8+aUF9H6JS/99n3A9xZXHXGNR52zt8
 vt/SGPT67mXTd/a/tUghFtPM=
X-Envelope-To: linux-unionfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4466a18d953500fa;
	Thu, 03 Sep 2026 09:11:41 +0000
X-Mizu-Trace-ID: 4466a18d953500fa
X-Migadu-Flow: FLOW_OUT
Message-ID: <de02c1f0-c675-4050-a2ee-2584eda63499@linux.dev>
Date: Thu, 3 Sep 2026 17:11:37 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] ovl: reject verity= together with userxattr
To: Amir Goldstein <amir73il@gmail.com>
References: <20260903064504.1052841-1-cui.tao@linux.dev>
 <CAOQ4uxhZOBv93_y4K0mc4PofprdPfSN8c45KW226LR-JO_BEkw@mail.gmail.com>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <CAOQ4uxhZOBv93_y4K0mc4PofprdPfSN8c45KW226LR-JO_BEkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Amir,

在 2026/9/3 16:09, Amir Goldstein 写道:
> On Thu, Sep 3, 2026 at 8:45 AM Tao Cui <cui.tao@linux.dev> wrote:
>>
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> userxattr forces metacopy off, and copy-up only computes and stores
>> the verity digest for metacopy inodes.  With "userxattr,verity=on"
>> (or verity=require) the mount succeeds, verity is advertised in
>> mountinfo, but no digest is ever generated and no lowerdata is ever
>> verified - the option silently does nothing:
>>
>>   $ mount -t overlay ovl -o lowerdir=$l,upperdir=$u,workdir=$w,userxattr,verity=on /mnt
>>   (mount succeeds; after copy-up the upper inode carries only the
>>    origin xattr, no metacopy xattr, no digest)
> 
> If metacopy is disabled, then the data of the upper file is in the upper file
> there is not supposed to be a verity signature for the upper file data
> verity signature is to attest the data of the lower file, so this report
> is strange.
> 
> Moreover, even though metacopy=off does not create new meta copies,
> it still respects existing metacopy xattr, which may very well also contain a
> verity digest, so the statement "silently does nothing" is inaccurate.
> 
> I admit that user xattrs for verity digest is an odd combination, but it does
> what it is supposed to do.
> 
> If you want to report a bug please explain how the security model gets
> broken.
> 

Thanks for the explanation.  I hadn't considered that pre-existing
metacopy xattrs are still respected regardless of the mount option,
and that with metacopy off the copy-up data lives in the upper file
where there is nothing to attest.  The patch gets this wrong, please
drop it.

The fs-verity section in overlayfs.rst does spell this out; I read
it too narrowly.

Thanks,
Tao

> Thanks,
> Amir.

