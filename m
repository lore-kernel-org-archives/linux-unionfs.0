Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795546686;
	b=EvLT/WGSmR7vb3HF3zj/z4xorWTbmRS9YQ5oeGXXQnvAq8wDjbZ0JIwPdU8xrd07nHYT
	 5XZb9MXngjSHW/xr8bJLR5KMTWzxvnRQgBrdUaXjPPXwvdhg0QRAMsc2dXf23BFOI6BK4
	 vRviyOC1MfmmPv8u2pZ5136X0Gg94zaVl+fRiy/TycmfF9Qc0K7Mz+RIBWB/n+0ITadm9
	 9eh0H0ONcuK7lEKxpCxZjsb1gexByjVcsYSytfnSGhG9KpTS6YTS1ngn4SKpa2KPYt8uk
	 Cd0MILAtB66YatPYpMwIM0l85KAX/1JBmnWrTx2ZGN/usxO9uYj5mRrg/zHe94VVqHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795546686;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=uqq04Dy6isK/nibhKSp5arYzUNNXHVOftTNvu6kl/OA=;
	b=WJ73aw6ylyPK4X6DHB2I2qVG+h9pZIYMOar+jqAU8y1Cg0lTfxh2wqlPygLCGB6+lcCk
	 OQ1x04U/UElsV56PRIh3Ml40OrC+xhJbuyvbPdear3HJWMMZ4O368sahmSl/3u64vwz/2
	 safvhhmFKqLFwMY6QaLFJqctjJpaDKhGGpEAm/ecZzXt3V+Kr3YSY0Ga6RDPM2cIWlhnM
	 bNk756dTN028PFe4+emmk7ih0iVX9e8OrT8U/r9J4tbwBfumw6NolYmGY5ZsyI5J8JsR3
	 GKPjkPhwc1UBPRh7KwiBDUgULLIUcWU+6nN2mF12aZ0cFx1z77yFxPwa+YVfvx1uhMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=HfV3u0oY;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF6E606A321;
	Tue, 24 Nov 2026 18:58:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FF6E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=HfV3u0oY
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOIYld43227618;
	Tue, 24 Nov 2026 18:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=uqq04D
	y6isK/nibhKSp5arYzUNNXHVOftTNvu6kl/OA=; b=HfV3u0oYsHK/2oysOj7z7w
	d/1edf/+i3BrSGx8kohgNwUJx3hS97CxKYZaqldB7DXk17NXBgKCtupb6asdpLnN
	W0BsbYY11JMsYv652cyBGcYMiF7aEsPYRQD+d82CbP1F3A/0FXkKSF0ri1aagOnA
	A6xBx9jHsZ3K2XH6prPoF/46EGIXu2JrhJd0iOVHc+tYh9HstEQDMfgFch0P+de4
	wGHTEcPdW4l5t4OhWn8iHXkIK9K19nBzIK/tM1vzVKhPXL/ISXCDSXRrFwJ1WNu9
	dLATIKrkr8gfkFcFePD/gsW/08nd+XuGFGz+kN2589qmZgiREA/zZdXYKd2ojFtw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g18taa-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 18:57:46 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOIZW7J3101401;
	Tue, 24 Nov 2026 18:57:45 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j3p0vkvhn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 18:57:45 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AOIurgx31195846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Nov 2026 18:56:54 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA14D58056;
	Tue, 24 Nov 2026 18:57:44 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C1A558052;
	Tue, 24 Nov 2026 18:57:44 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.4.47])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Nov 2026 18:57:44 +0000 (GMT)
Message-ID: <d22a4eafc73dcb6d2c80862f422fe69d54e79f4b.camel@linux.ibm.com>
Subject: Re: [PATCH v2 06/13] ima: handle errors from resolving the real
 inode
From: Mimi Zohar <zohar@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>,
        Amir Goldstein
 <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi
 <mszeredi@redhat.com>,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20261116-work-ovl-d_real-v2-6-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
	 <20261116-work-ovl-d_real-v2-6-90564c4ae347@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:57:43 -0500
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Evolution 3.58.3 (3.58.3-2.fc43) 
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: yZjGn-DEeq1kE4tVMh88FNtfLffg03sv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA3MyBTYWx0ZWRfX61M3IaFKEsaH
 7mS6MNfRj/IINRdNIeW6tGSQh3Ue5NbtgMDCNRXnLJ5OBU41aPp0+wD1i+vutgxz/3h/j9mJs5G
 Kea5URj1fxQhihtFOZid/BAAI03/vXQ=
X-Proofpoint-GUID: NedgcETWwMWTjELFHod-RGSG4ukHSub7
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b05de2a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=lMkFumaAjUwUa6GXabIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA3MyBTYWx0ZWRfXyr1nQkXtkjai
 DyvG50RFNvMZx7HXm6G4R2VhVPWuhpDl0ODZObKFI/5i9UjVKCRWDNEtYSBwO5tR18KcDHXxbjS
 WeC8RQlng8HO9axVheyKPB/GnxVt127Z7IbLPYelZK9I9G09/Q+VnYJPoDLQyl80iQTsQJHRbGF
 JYrcAG4FYcRLeWBrTy81y2EXqZ+jT9zu5ZQoHnG7iLDSE9L980eeEWLawlLzTDPqHXA1Mhbw1Qm
 1QQqDxnUDyJNXMssDkwH/MD6ocinO5NE4vU258iOrRj0CCJnu4XKi8oB0UnO5s/y7Q3J9o5+N/e
 nE/aH7AaB4PGybrLyST/CIMwLQaOOiFWe9FGTSvm/Mt4NRQNNfD+pATTeprrWDUCjG4UPWnCTov
 sSb3/51afK0h8df7UmmItmgeHTWtIxX4F9NjEBaq9M0GN6z8AU0TqTfCCEdB1UFWgkp2t+BOj0Q
 oCK32Ok7gkRButWmKQw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_05,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240073

On Mon, 2026-11-16 at 10:44 +0100, Christian Brauner wrote:
> d_real() is about to be able to fail for D_REAL_DATA. So switch IMA
> from d_real_inode() to d_real_data_inode() and deal with the error.
>=20
> Currently, if overlayfs fails to resolve the data of a file it hands
> back the overlayfs inode. process_measurement() then sees
> real_inode =3D=3D inode, skips the detection of changes in the backing fi=
le
> and returns the cached verdict. That's the wrong default. With
> metacopy and verity this isn't limited to files nobody opened yet
> either. A metadata-only copy-up of an open file makes overlayfs validate
> the verity digest of the data again on the next D_REAL_DATA lookup and
> that can fail.
>=20
> So if the inode hosting the data can't be resolved in
> process_measurement() we can't tell whether the data changed. Treat it
> like a change and clear IMA_DONE_MASK and measured_pcrs so the file is
> evaluated again. The metadata check for EVM stays independent of that.
>=20
> This is a no-op until d_real() can actually fail.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

The patch, itself, looks fine, but I'm not able to reproduce the error.

The existing IMA overlay tests are working with and without this patch set.=
  The
tests check:
* test 1: checks file signature is copied
* test 2: checks backing file signature is copied up to overlay
* test 3: detects modified backing file

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

Mimi
