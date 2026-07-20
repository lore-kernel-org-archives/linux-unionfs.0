Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34E0346AD6;
	Mon, 20 Jul 2026 08:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784536934; cv=none; b=mj0J6XToXvPr7/y/0G7ztixMpPWE3pLp+b659gWKggE+QxwOwIz7+Bq4J8Q2OMQtlmumrtQ8aFU9NKeXZyBmWIMhmeqreZMAZMFQ1qpLyFFu7Ga9j4G04WNIUaBqJnIh/NzCtKh6Pa5SlJ4ayv2V44uhmBrUemyuZITqCAenyWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784536934; c=relaxed/simple;
	bh=nI99RKEQaOznpgP3tAPD0uhF5MOyKzJhOFNy2RFqLoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lTWxlgbKPmrgf9BoRP9xNEsPNrZEEXPZMcCv+G02i3Jz2rHURExU5YIspa68GyTOcAdkhVKz1x6ODdZOE9ytjL4pbT0Pdlupe9/ZXpQF9dx7+Jysq+9aT5/BmIM6f5GENOWv3L9t6lcywFtUokHXzRaxERS8yvi9ScpUtmUUrYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=srmRA4gE; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="srmRA4gE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784536929; x=1785141729; i=quwenruo.btrfs@gmx.com;
	bh=Kp84QlBWz5kesqACP/yIHTY2nkNZw8oqLOoXuaa2+KI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=srmRA4gEiOUnyyUCbZVq/wi/BbdbZz0ehwxSKWyVkJ8kvV2FLT70JPcpcrzG4RGS
	 0pU3hF5TGcLXGzPdA6q13usSx+K6DOjTwzMcHV33OJzF5qU7jtC7RbsfuDIVue0ES
	 L15aGcLk4iFl5oYrFKC0+ahbqsQvHHplxVom79SPTrASifNaDONitXknt0l3+n/K5
	 KmJeBqBaFfkJgK1n9UoVO3PRj+eSIFhcS9WPw2+9Ckvrc0mTWMq7vb00bFHYkjvbQ
	 ChFB7tcatxXDznDAVdRqXFzdVaZ0ogcSOP0jL3Z68Z+gr44K83QcJGOG5L+1o0y88
	 st17THlPOZQe+AXtCA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MtfNl-1x05Ow1AJL-016z77; Mon, 20
 Jul 2026 10:42:09 +0200
Message-ID: <b09076d9-e459-4c15-8d66-5c9c33da7562@gmx.com>
Date: Mon, 20 Jul 2026 18:12:04 +0930
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: vfstest: skip rejected tmpfile creation
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260717070717.113517-1-wqu@suse.com>
 <al3YDuYk81NY9mBE@infradead.org>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <al3YDuYk81NY9mBE@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EnSUZbDOdKCpd73uYZ3ue/Lw3gDXyCUgpjVvYP4aon1NXoTh+7l
 k3jAMwVvp90Ru1uOS79m7o9NlsvxljGdX6zq/0kZVw/jl3zpUjGpLZOeWa6Ftv6t+ciUxYv
 kXGUrtCF9gNpDN6bnkUfJ230xS7lbWwsrZNK+sfB1wIYol/zi1GhZacC8sJzOLOXPrZn/IX
 fU/A6AekJ8hxh0dCaYuZQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:E+5mf6ST7yM=;6IVyGYswul1WjwJntQdaTJuwCa3
 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
 kmI5TYQa2+cPeaZVzs5W3mOn+KiIzZ



=E5=9C=A8 2026/7/20 17:40, Christoph Hellwig =E5=86=99=E9=81=93:
> Christian indicated the fixes for this are in the (somewhat confusingly
> titled) "[PATCH 0/2] Support overlayfs in the idmapped mount tests"
> series.
>=20
> It would be good to get a proper review for this as it's beyond my
> pay grade.

Thanks a lot for pointing that series out.

That series hit me but the name didn't ring my bell initially.

But the commit message of the first patch makes more sense now, and=20
please drop this patch.

This one is really masking the problem, meanwhile that first patch of=20
that series is fixing it in a better way.

Please drop this patch.

Thanks,
Qu
>=20
> On Fri, Jul 17, 2026 at 04:37:17PM +0930, Qu Wenruo wrote:
>> Since kernel commit 539dce114465 ("fs: refuse O_TMPFILE creation with a=
n
>> unmapped fsuid or fsgid"), tmpfile creation can be rejected with
>> EOVERFLOW, so also skip that error number to avoid false alerts like th=
e
>> following:
>>
>>   FSTYP         -- ext4
>>   PLATFORM      -- Linux/x86_64 btrfs-vm 7.2.0-rc3-custom+ #411 SMP PRE=
EMPT_DYNAMIC Fri Jul 17 16:24:34 ACST 2026
>>   MKFS_OPTIONS  -- -F /dev/mapper/test-scratch1
>>   MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/test-scratch1 /mnt/scr=
atch
>>
>>   generic/633  1s ... - output mismatch (see /home/adam/xfstests/result=
s//generic/633.out.bad)
>>      --- tests/generic/633.out	2022-05-11 11:25:30.816666664 +0930
>>      +++ /home/adam/xfstests/results//generic/633.out.bad	2026-07-17 16=
:25:45.033967541 +0930
>>      @@ -1,2 +1,4 @@
>>       QA output created by 633
>>       Silence is golden
>>      +utils.c: 948: openat_tmpfile_supported - Value too large for defi=
ned data type - failure: create
>>      +utils.c: 948: openat_tmpfile_supported - Value too large for defi=
ned data type - failure: create
>>      ...
>>      (Run 'diff -u /home/adam/xfstests/tests/generic/633.out /home/adam=
/xfstests/results//generic/633.out.bad'  to see the entire diff)
>>   Ran: generic/633
>>   Failures: generic/633
>>   Failed 1 of 1 tests
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   src/vfs/utils.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/src/vfs/utils.c b/src/vfs/utils.c
>> index 0b435afe..d2922cc3 100644
>> --- a/src/vfs/utils.c
>> +++ b/src/vfs/utils.c
>> @@ -941,7 +941,11 @@ bool openat_tmpfile_supported(int dirfd)
>>  =20
>>   	fd =3D openat(dirfd, ".", O_TMPFILE | O_RDWR, S_IXGRP | S_ISGID);
>>   	if (fd =3D=3D -1) {
>> -		if (errno =3D=3D ENOTSUP) {
>> +		/*
>> +		 * Kernel commit 539dce114465 ("fs: refuse O_TMPFILE creation
>> +		 * with an unmapped fsuid or fsgid") will reject such operation.
>> +		 */
>> +		if (errno =3D=3D ENOTSUP || errno =3D=3D EOVERFLOW) {
>>   			errno =3D 0; /* Don't report misleading errno. */
>>   			return false;
>>   		} else {
>> --=20
>> 2.51.2
>>
>>
> ---end quoted text---
>=20

