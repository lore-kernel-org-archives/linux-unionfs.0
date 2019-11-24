From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] utimes: Clamp the timestamps in notify_change()
Date: Sun, 24 Nov 2019 22:50:23 +0200
Message-ID: <CAOQ4uxjsOM+th1f4=wss4SCrwueUYuVT0FKX0GxtmHBG2juw+A@mail.gmail.com>
References: <20191124193145.22945-1-amir73il@gmail.com>
 <20191124194934.GB4203@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20191124194934.GB4203@ZenIV.linux.org.uk>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Miklos Szeredi <miklos@szeredi.hu>, y2038@lists.linaro.org, Jeff Layton <jlayton@kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Deepa Dinamani <deepa.kernel@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

T24gU3VuLCBOb3YgMjQsIDIwMTkgYXQgOTo0OSBQTSBBbCBWaXJvIDx2aXJvQHplbml2LmxpbnV4
Lm9yZy51az4gd3JvdGU6Cj4KPiBPbiBTdW4sIE5vdiAyNCwgMjAxOSBhdCAwOTozMTo0NVBNICsw
MjAwLCBBbWlyIEdvbGRzdGVpbiB3cm90ZToKPiA+IFB1c2ggY2xhbXBpbmcgdGltZXN0YW1wcyBk
b3duIHRoZSBjYWxsIHN0YWNrIGludG8gbm90aWZ5X2NoYW5nZSgpLCBzbwo+ID4gaW4ta2VybmVs
IGNhbGxlcnMgbGlrZSBuZnNkIGFuZCBvdmVybGF5ZnMgd2lsbCBnZXQgc2ltaWxhciB0aW1lc3Rh
bXAKPiA+IHNldCBiZWhhdmlvciBhcyB1dGltZXMuCj4KPiBNYWtlcyBzZW5zZTsgc2FpZCB0aGF0
LCBzaG91bGRuJ3Qgd2UgZ28gdGhyb3VnaCAtPnNldGF0dHIoKSBpbnN0YW5jZXMgYW5kCj4gZ2V0
IHJpZCBvZiB0aGF0IHRoZXJlLCBub3cgdGhhdCBub3RpZnlfY2hhbmdlKCkgaXMgbWFkZSB0byBk
byBpdD8KPgoKU291bmRzIHJlYXNvbmFibGUuIEJ1dCBJJ2QgcmF0aGVyIGxlYXZlIHRoaXMgY2xl
YW51cCB0byBEZWVwYSwKd2hvIGRpZCBhbGwgdGhpcyB3b3JrLgoKVGhhbmtzLApBbWlyLgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5n
IGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFp
bG1hbi9saXN0aW5mby95MjAzOAo=
