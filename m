Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519DC2528E8;
	Tue, 29 Apr 2025 18:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745951683; cv=none; b=uQgApZFDUcaXQpnRbnqQynYKlmRmZHjc7OA5fSKMNdf/9j0fHhCpKaln0I2sxgf9kkjCvV7EY4QIKl/0fj36Q4cnHc4/eAQ26bveL3icxPKVyUf534zo/gSkoifrFw71M8m2o/JbR9v8YxAnnLoF7kdATUA6FpWCphE0bxEzHCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745951683; c=relaxed/simple;
	bh=41tclrCsWgVjaUFv9lP7EsVrzCxEebaVZvRPv9A2NEk=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=VnQL3mEA12tbuCFcIc4nUivxx5iGNKs2doc04N5/JE8jjn5uiOxb5+BBTeuW54R2FLGdmuPbVrqHz4FleJIrBdirx2VOn7n/IniGnHwHUYC8NLzA8YLmyt1vTDV9+bhPleMKEqksO9kDI/F6OExDWAiCliDaDvvId8XkuszZzgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=hAo3P+K5; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="hAo3P+K5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1745951667; x=1746556467; i=markus.elfring@web.de;
	bh=+rsVdTepre0Pi7lEPZYfPiKD9GfSf6QYsCBwWPVofh0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=hAo3P+K53QRMizvDeuKSoxJ7L+OMted8D1EE00HgAbE7wwlhWXE279RQwFfBXTxe
	 HQ50PPoXFhcM04UOfxGKEDnfBFz8Pz0FmRIzkGqGrEozvvwlddDzzEJazVZr2xp5t
	 IoOklAvRsH98Mmbj0Hitcj9+6gSauqDML5TgKLWgfwK13NywpAyyZUeIokMaCsecS
	 2QezgbL5akKekqqBH7LfUwR/s9k1Fw31bwuBJf8++7EQrq2J6tUyOUI1HrUZTDB1L
	 FnIt+BOBYX7L9Uia+Np2j6e+RsRtjJR/Eo4WL997ooLXFrw+BXrzz00l1jr4voJmT
	 Gd8PD7OOjv6zPpeH5Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.70.57]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MI3t5-1uFcvs3QBz-001aDj; Tue, 29
 Apr 2025 20:34:27 +0200
Message-ID: <d1eeea14-4a5c-4f7e-9e54-e552bc1d239f@web.de>
Date: Tue, 29 Apr 2025 20:34:25 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Wang Zhaolong <wangzhaolong1@huawei.com>, linux-unionfs@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Yang Erkun <yangerkun@huawei.com>,
 Zhang Yi <yi.zhang@huawei.com>
References: <20250429001308.370040-1-wangzhaolong1@huawei.com>
Subject: Re: [PATCH] overlayfs: fix potential NULL pointer dereferences in
 file handle code
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250429001308.370040-1-wangzhaolong1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HF4vr7p1Bjnx7w0LLVjJ379RRI22o6z9QNnFg5nuaS2yighqZUG
 8s4KYbvHVjlRw9taQBIMlCSjzcXkxMKMTID6lW4vbTGvpKH0h2uCOv3SuKmzkB8GD/8T8u6
 ftcUNPlbmGX0ICbJiLstlmyfthgZ+Py7pRKB7JJX7bpSidA6IUlUD7Ts+7ve1JdivzoTrEo
 RavxqsM4Ets72FtofegfA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/r9VgK28N/A=;xMRr12plasW+NV4Wx7e7BfgmA2/
 VkGTLFC5ruHo8jnQVDtrCxKl8tXvAz8V3/9bsG1yCkUJXxg3I8DwrCVOxPtbFC9ICcztYnXZ/
 +9rsxSeGgfgiM+OiyFw/tslQ4ZaO+UWmoIeP+SMYqGM/8PNHy0OXnoh0OXz46971JdGrOSow5
 diDVxPtcigA/E5UNhNoIQiiKstfGIK6ndPmFV3Eq6NQ0PDUr4Uw1IpqKDmKRWySQoH1KNJC4V
 PyhiH0nE3IbOOY5JY1a458zS5umdkzWyqJG2EUJJrw3i93WMJfIDhRhkMkTo4GNPiVKSitTpo
 wQ4fCRXzPUoXOXV+10eqVwPPz2plZj6LgxtWWq+THywARaiVD42vFco0/MomRqt/n9X0+lw8o
 DNYk+y7sq+bPIbkWF043nVUtY2gewBBigRePu7AsXudOeUiaV3v1CDDJkf4REhnmcTlPeZGhS
 iw/tpHpYaa8rO0KKvlw8QAGnR6HOlqTnO01QIR6nXLN378PGwVFX2K4SwoC0Rer2B+1zVWotL
 cieVWe/N6LQFe8CLB7ULgxm/6HfP3so4VvkSCUV9KPX/322pV8Z5ff0EKj5G6mv80kLUr3E3D
 y0AHWc5XsViYd8Zi8qKIBQ3GvOSf3sorzK4XXRMLkUp8FbHAj2InPrN1vJG+/gBKjxrZJTgcH
 4kjlIoRXtyOsXGqvu5hqvYsPhtEdfBQ4FcKUl8RPgpCshx/HS4d93hG7Isw009ltZHDhwH7Qv
 iuIbZx1E/KhoWDHbldsVDmeLgNsKfTe25eT3/M4KzjDnvj2jAjlbFvnn2EDbyVySpTAg9yq1k
 I+cLs4Lvn4IoOmY0d2um+HnE+dHnGix4e0vv1PNiK8H0/z4oLqWS3ZYiBltdAk/KvXdyVAXMR
 pKljz9qgD/jfUItfthMFVyot48sl0Dk5YmxnJjXZVTafMmHCPI7yvZ8/mfpZ6g+7yrLaJpEc7
 zxmF2nfnqs1CLB8yFA1fZAXThYck3xJdlklc9XUkAXY6tC8JF6Yj37L2wLhlsSTpkfRjdxLZp
 1HvRo2XbMjWAYC6sR2Rm85twzaOJnXSZCqVuCJ3eUykHJJbHPw6JHSC/YZhiCe71gsGk9LHzh
 GYaITduSzlG+jV0S9mCR7oc7Nz5Z4tqhqLjIcwN1mhiRPdiYgw/1HqlRxP3xxzhD26OB2wzs1
 v3mI/Y3Rsvm3fpbjXIJKW3ND5zj8X9xx/iGBbKixxLsKhHLvlbcQqrlvZTwOpDweJ9i5QNEb2
 +1R0GPuYUUNHP6guNQAnzOyMtIyAX4XsgDoCBYNS13K8JvWHbf7fz35e4hsg+/FNTPPAkimsD
 XEpjyMKMzsOhOH/c9z8IWt2brf8lLjnfhPd2wnEEbWF/QWQZWzACSBfw7NEyMaMlComHwbLlb
 bqkWXsvlm+jInw/wSvXgLBhjXWKzvPooRD6mjjA+pSsJUg16EH/dkyQtuASuJGu/MApFNWwl0
 F8iVpfnAynM1ij386w1k0dDYf7PmPvEuTIW9TNfEZlDn0qsnRoo+Don6ll5GlYFD28c9U4Gxs
 jQs6X+PAPCimnCB+M2hH3V3J+Phso6Z7YisGDfNwgyBp6stF7hN1PW1BMRFiF7TiNBkWOkNCh
 TnRR2+PZWGjW/L2YUtxOP1q9HlfNft7OGkyn5GChSDJJ2KKjednqIoMqt7Dt2h8lrYDSDBsm6
 6zQulO2Ow3IwNlUuw6mUYgzQB+Jmd1uOmmEGAsKd3C07wAw3I4LCPg9vRoaTANMLkj0kZlRDh
 gv4clwlyKoDchy8QzbbqrrtFDfVFpThAEphOtULvFL7i1J56DEMNrvSKN2HCN8RXxi93pEFKr
 7QtsNQ1UpqACLeoLO8m/eSVHRjB4IwDbc/SWPGwgGyuSJ7xoTrjQ5gGGdhrLBEjXkrtN4DBjS
 4HeD2dKRPLiIAuiMYmLMpzNWVH2A2B/aJHg7yiX/zWENkydEoF7+oq8GEopM1ixGMAAtTPhcM
 msBQBurYNvKmwyJwWPsioA7UrqpkZlZUpUsEOdNrGwmOb+ukUmvsIeQgj4CmmtKtQPTD6bRCf
 83cuC0wHFCE3q579H3l2F02ftn3HcejaxOy4scPy4CztTUl/Md9DxXZ1TsBVWUkKTTZCGqcmi
 dQ+R6Ca7SXfUm4jKKlGtCSBfvecnlGgjomQq4eMQ2Z0CvVVn9sc32L76U1DFxqeBDws/VqKfR
 jCxaUxbccm5eGjwnO/etFVn4F00HL0hNVMlv/68//KbCbzMm2+f13I1AjdujgzrOL9QyCukPy
 D6eS3NBCinGzv1zNNr1fKAI5O9Xtb7FmaZc3P/0PPDwmwuqI1fmQ1BwuINvwyAHcLYiqm2maJ
 dEsGP/iXpsI4jY9K1B/6cHK2SeH61sDSjh+XAM4k8Gf70/EtHQxpfvigc3t+EN986VOkHUmKr
 VTMRFs7MSUpbxBUUTYJvs7fvxKQD3xGAb+Rgzl3FEZREyjMKGy6jHViTKgBmhZuxfKJAHga4l
 suq9yv2P4MWLGzAhGMQZQF0mWzsN2mgiUvT407WtxbMHv/AoOp0LtFxq01Dvgtp1E8QpsM3cM
 0txg0LaVuqfwHKFtBfx94DYwQg1hRfuIkJ+gMWDk9RoiAxc1W+aYA6J85bXDf8kJDKfBNN90d
 1UXbt3VaeuB1wCpLpxy8rhyxHOIePbu/vaBds7oZ2L+jGhTbrVQj+3O025Xyf63egOnJ5B72K
 0Yo/F4XER56jLyq9eFeVq3Rw9/y5lieD/18NiS+Us2gLdHLnMZhnXqLrN1O+pYNZFhbrzHgRC
 UP1Z0tth6DD5hehjsrLWqfNjt4+ipD8C6l0mlBgheE1RAtAqwsA3jR1kbr9xBi3QTelUUl7iy
 QidLNwWM5sT1QDwiPAz8JIw7sNrJOz/IsuFVl08ErYxk7aAr+O8RuG2QLlZQqgqWD2SzUhp9G
 8bWLIbafilaoN7bfLIouIcKN6LXV/LG5qS715Pbwnk0Gv326MPbLQHdL091h/wAfsdnmfew8a
 MwlZZ+j4wShhR/ekzNstGXdeKgI0FN6JDQn1iUO4p4vpT4uUml5S0zdsqLKq3F5Ft7GdF3VMA
 OD7+U0+ZEMqF3zvPZ9VLP4=

=E2=80=A6
> Fix these potential NULL pointer dereferences by adding appropriate NULL
> checks before accessing the file handle structure members.

How do you think about to omit the word =E2=80=9Cpotential=E2=80=9D here?


> V1 -> V2:
> - Reworked ovl_verify_fh() =E2=80=A6

* You may specify patch version descriptions behind a marker line.
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv6.15-rc4#n796

  Please synchronise the version indication in the subject prefix accordin=
gly.

* Would you like to reconsider the assignment also for the variable =E2=80=
=9Cerr=E2=80=9D similarly?


Regards,
Markus
