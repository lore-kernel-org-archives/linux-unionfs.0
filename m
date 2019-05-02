From: "Goetz, Patrick G" <pgoetz@math.utexas.edu>
Subject: Re: [PATCH] overlayfs: ignore empty NFSv4 ACLs in ext4 upperdir
Date: Thu, 2 May 2019 17:26:56 +0000
Message-ID: <8f3ba729-ed44-7bed-5ff8-b962547e5582@math.utexas.edu>
References: <CAJfpeguwUtRWRGmNmimNp-FXzWqMCCQMb24iWPu0w_J0_rOnnw@mail.gmail.com>
 <20161205151933.GA17517@fieldses.org>
 <CAJfpegtpkavseTFLspaC7svbvHRq-0-7jvyh63+DK5iWHTGnaQ@mail.gmail.com>
 <20161205162559.GB17517@fieldses.org>
 <CAHpGcMKHjic6L+J0qvMYNG9hVCcDO1hEpx4BiEk0ZCKDV39BmA@mail.gmail.com>
 <266c571f-e4e2-7c61-5ee2-8ece0c2d06e9@web.de>
 <CAHpGcMKmtppfn7PVrGKEEtVphuLV=YQ2GDYKOqje4ZANhzSgDw@mail.gmail.com>
 <CAHpGcMKjscfhmrAhwGes0ag2xTkbpFvCO6eiLL_rHz87XE-ZmA@mail.gmail.com>
 <CAJfpegvRFGOc31gVuYzanzWJ=mYSgRgtAaPhYNxZwHin3Wc0Gw@mail.gmail.com>
 <CAHc6FU4JQ28BFZE9_8A06gtkMvvKDzFmw9=ceNPYvnMXEimDMw@mail.gmail.com>
 <20161206185806.GC31197@fieldses.org>
 <87bm0l4nra.fsf@notabene.neil.brown.name>
 <CAOQ4uxjYEjqbLcVYoUaPzp-jqY_3tpPBhO7cE7kbq63XrPRQLQ@mail.gmail.com>
 <875zqt4igg.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <875zqt4igg.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <E61925DA62D1E54E930FFD18D9DA927D@namprd06.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Amir Goldstein <amir73il@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, =?utf-8?B?QW5kcmVhcyBHcsO8bmJhY2hlcg==?= <andreas.gruenbacher@gmail.com>, Patrick Plagwitz <Patrick_Plagwitz@web.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Linux NFS list <linux-nfs@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

T24gNS8xLzE5IDEwOjU3IFBNLCBOZWlsQnJvd24gd3JvdGU6DQo+IFN1cHBvcnQgc29tZSBkYXkg
c3VwcG9ydCBmb3IgbmZzNCBhY2xzIHdlcmUgYWRkZWQgdG8gZXh0NCAobm90IGEgdG90YWxseQ0K
PiByaWRpY3Vsb3VzIHN1Z2dlc3Rpb24pLiAgV2Ugd291bGQgdGhlbiB3YW50IE5GUyB0byBhbGxv
dyBpdCdzIEFDTHMgdG8gYmUNCj4gY29waWVkIHVwLg0KDQoNCklzIHRoZXJlIHNvbWUgcmVhc29u
IHdoeSB0aGVyZSBoYXNuJ3QgYmVlbiBhIGdyZWF0ZXIgZWZmb3J0IHRvIGFkZCBORlN2NCANCkFD
TCBzdXBwb3J0IHRvIHRoZSBtYWluc3RyZWFtIGxpbnV4IGZpbGVzeXN0ZW1zPyAgSSBoYXZlIHRv
IHN1cHBvcnQgYSANCmh5YnJpZCBsaW51eC93aW5kb3dzIGVudmlyb25tZW50IGFuZCBub3QgaGF2
aW5nIHRoZXNlIEFDTHMgb24gZXh0NCBpcyBhIA0KZGFpbHkgaGVhZGFjaGUgZm9yIG1lLg0KDQpB
bHNvLCBpdCBkb2Vzbid0IHRha2UgbXVjaCBuZWVkIGZvciBzZWN1cml0eSBncmFudWxhcml0eSB0
byByZWFsaXplIHRoYXQgDQpQT1NJWCBBQ0xzIChub3QgZXZlciBldmVuIGZvcm1hbGx5IHN0YW5k
YXJkaXplZCEpIGFyZSBmYWlybHkgaW5hZGVxdWF0ZSwgDQpidXQgbW9yZSBpbXBvcnRhbnRseSwg
ZG9uJ3QgcGxheSBuaWNlbHkgd2l0aCB0aGVpciBXaW5kb3dzIGZyaWVuZHMuDQoNCg==
