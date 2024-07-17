Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D6641C63
	for <linux-unionfs@vger.kernel.org>; Wed, 17 Jul 2024 12:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721220095; cv=none; b=W//3fZG+2LSpwK6tid1c5v97QGQrbyPs2Y5ecpsKsf55T+iUMjUeNXCXBUklh703SoNMJYBWVkriGb2S9j+8+0D2OZQjT0pWAmETEJpx9Qkrd1R4fwRD7PDo4/B7nnAyrGvX12DD4nY6BJMOFEbViN+Za1VhUXedI1YwoZEnOg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721220095; c=relaxed/simple;
	bh=jyiCJIL9+EqSP3CUbgMki0EonhbQJnm5rU3trO3Zk30=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WEb963ukByxL7XbAX4Z+2LjiIphPkn8KkGc59L8qapASMZqgVRQkYJt6eNyj4U05FhbkupOm4FFW2lIMPwfmrmn0Bk3/C23ZLdmhCIecx5BVrwhUkD10yRrGW/bTV+SP8C3KArl0JeQ6FEjiPELOmN2pWL9KYVXqIb2EtMAn9Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch01.asrmicro.com (exch01.asrmicro.com [10.1.24.121])
	by spam.asrmicro.com with ESMTPS id 46HCf9ZN098238
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Wed, 17 Jul 2024 20:41:09 +0800 (GMT-8)
	(envelope-from feilv@asrmicro.com)
Received: from exch01.asrmicro.com (10.1.24.121) by exch01.asrmicro.com
 (10.1.24.121) with Microsoft SMTP Server (TLS) id 15.0.847.32; Wed, 17 Jul
 2024 20:41:13 +0800
Received: from exch01.asrmicro.com ([::1]) by exch01.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Wed, 17 Jul 2024 20:41:01 +0800
From: =?utf-8?B?THYgRmVp77yI5ZCV6aOe77yJ?= <feilv@asrmicro.com>
To: Amir Goldstein <amir73il@gmail.com>
CC: "miklos@szeredi.hu" <miklos@szeredi.hu>,
        overlayfs
	<linux-unionfs@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBvdmVybGF5ZnMgaXNzdWU6IGRpciBwZXJtaXNzaW9uIGxvc3Qg?=
 =?utf-8?Q?during_overlayfs_copy-up?=
Thread-Topic: overlayfs issue: dir permission lost during overlayfs copy-up
Thread-Index: AdrUC0gEiOU98wx1R2KKZaM5fXllRAABtu/g///UyID/+v9iQIAJvw0A//5hsICAAxJygP/9oC2A
Date: Wed, 17 Jul 2024 12:41:00 +0000
Message-ID: <1393d3786fc54f05a661eb41394dc982@exch01.asrmicro.com>
References: <a2391c78f3974c5d92aa53574bde4eca@exch01.asrmicro.com>
 <CAOQ4uxj-pOvmw1-uXR3qVdqtLjSkwcR9nVKcNU_vC10Zyf2miQ@mail.gmail.com>
 <d75ce286091046438f8828554eb3f781@exch01.asrmicro.com>
 <CAOQ4uxhJET3v7+7+Cw-wnsRbpPa6ufRDFYaGYWD9RYLgfUxRZA@mail.gmail.com>
 <47d8bf2202a943e5967454499ee61248@exch01.asrmicro.com>
 <CAOQ4uxgPSrjA20EAHeoGxjtE7odO6t1V1O4abOwUW8J2rTDBOw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgPSrjA20EAHeoGxjtE7odO6t1V1O4abOwUW8J2rTDBOw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 46HCf9ZN098238

DQo+IC0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCj4g5Y+R5Lu25Lq6OiBBbWlyIEdvbGRzdGVpbiBb
bWFpbHRvOmFtaXI3M2lsQGdtYWlsLmNvbV0gDQo+IOWPkemAgeaXtumXtDogMjAyNOW5tDfmnIgx
NuaXpSAxNjoxOQ0KPiDmlLbku7bkuro6IEx2IEZlae+8iOWQlemjnu+8iSA8ZmVpbHZAYXNybWlj
cm8uY29tPg0KPiDmioTpgIE6IG1pa2xvc0BzemVyZWRpLmh1OyBvdmVybGF5ZnMgPGxpbnV4LXVu
aW9uZnNAdmdlci5rZXJuZWwub3JnPg0KPiDkuLvpopg6IFJlOiBvdmVybGF5ZnMgaXNzdWU6IGRp
ciBwZXJtaXNzaW9uIGxvc3QgZHVyaW5nIG92ZXJsYXlmcyBjb3B5LXVwDQo+IA0KPiA+IEFuZCBm
b3IgdmVyc2lvbiA1LjQuMjc2LCBJIG5lZWQgdG8gYWRkIGZzeW5jIGF0IHRoZSBlbmQgb2Ygb3Zs
X2NvcHlfdXBfaW5vZGUgKGNvcnJlc3BvbmQgdG8gbGF0ZXN0IGZ1bmN0aW9uIG92bF9jb3B5X3Vw
X21ldGFkYXRhKSwgcmlnaHQ/DQo+ID4NCj4gDQo+IFNvdW5kcyByaWdodCwgYnV0IEkgZG8gbm90
IGhhdmUgdGltZSB0byBleGFtaW5lIG91dC1vZi10cmVlIGJhY2twb3J0IGVmZm9ydC4NCj4gRmly
c3QsIHlvdSBuZWVkIHRvIHByb3ZpZGUgYSB3b3JraW5nIGFuZCB0ZXN0ZWQgcGF0Y2ggZm9yIHVw
c3RyZWFtLg0KPiBJZiB0aGF0IGdldHMgYWNjZXB0ZWQsIHdlIGNhbiBkaXNjdXNzIGJhY2twb3J0
aW5nIGVmZm9ydHMuDQo+IEJ1dCB0aGUgZ2VuZXJhbCBpZGVhIGlzIHRoaXM6DQo+IG92bF9kb19y
ZW5hbWUoKSBzZXJ2ZXMgYXMgdGhlICJhdG9taWMiIGNvcHkgdXAgb3BlcmF0aW9uIGV2ZXJ5dGhp
bmcgdGhhdCBoYXBwZW5zIGJlZm9yZSB0aGF0IHdpbGwgbm90IGJlIG9ic2VydmVkIGFmdGVyIGNy
YXNoIGlmIHJlbmFtZSBkaWQgbm90IGhhcHBlbi4NCj4gDQo+IFRoZSBwcm9ibGVtIGlzIHRoYXQg
aW5vZGUgbWV0YWRhdGEgY2hhbmdlcyB0aGF0IGhhcHBlbmVkIGJlZm9yZSByZW5hbWUgYXJlIE5P
VCBndWFyYW50ZWVkIGJ5IFBPU0lYIHRvIGJlIG9ic2VydmVkIGFmdGVyIGNyYXNoIGV2ZW4gYnkg
cmVuYW1lIGlzIG9ic2VydmUgdW5sZXNzIGZzeW5jKCkgaXMgY2FsbGVkIG9uIHRoZSBzb3VyY2Ug
aW5vZGUgYmVmb3JlIHJlbmFtZS4NCj4gDQo+IFRoYW5rcywNCj4gQW1pci4NCg0KT0ssIEkgZmlu
aXNoZWQgYSBwYXRjaCBiYXNlZCBvbiA2LjEwIHRvZGF5LCB3aWxsIHBvc3QgZm9yIHJldmlldy4N
Cg0KVGhhbmtzLA0KRmVpDQo=
