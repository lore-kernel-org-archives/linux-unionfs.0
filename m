From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] utimes: Clamp the timestamps in notify_change()
Date: Mon, 25 Nov 2019 19:35:12 +0200
Message-ID: <CAOQ4uxh3OMmVotx-v9Lnvwcs7zxeBs9Ag9Q0uUK6f2v2Yqto5Q@mail.gmail.com>
References: <20191124193145.22945-1-amir73il@gmail.com>
 <20191125164625.GB28608@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20191125164625.GB28608@fieldses.org>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Miklos Szeredi <miklos@szeredi.hu>, y2038@lists.linaro.org, Jeff Layton <jlayton@kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

T24gTW9uLCBOb3YgMjUsIDIwMTkgYXQgNjo0NiBQTSBKIC4gQnJ1Y2UgRmllbGRzIDxiZmllbGRz
QGZpZWxkc2VzLm9yZz4gd3JvdGU6Cj4KPiBPbiBTdW4sIE5vdiAyNCwgMjAxOSBhdCAwOTozMTo0
NVBNICswMjAwLCBBbWlyIEdvbGRzdGVpbiB3cm90ZToKPiA+IFB1c2ggY2xhbXBpbmcgdGltZXN0
YW1wcyBkb3duIHRoZSBjYWxsIHN0YWNrIGludG8gbm90aWZ5X2NoYW5nZSgpLCBzbwo+ID4gaW4t
a2VybmVsIGNhbGxlcnMgbGlrZSBuZnNkIGFuZCBvdmVybGF5ZnMgd2lsbCBnZXQgc2ltaWxhciB0
aW1lc3RhbXAKPiA+IHNldCBiZWhhdmlvciBhcyB1dGltZXMuCj4KPiBTbywgbmZzZCBoYXMgYWx3
YXlzIGJ5cGFzc2VkIHRpbWVzdGFtcF90cnVuY2F0ZSgpIGFuZCB3ZSd2ZSBuZXZlcgo+IG5vdGlj
ZWQgdGlsbCBub3c/ICBXaGF0IGFyZSB0aGUgc3ltcHRvbXM/ICAoRG8gdGltZXN0YW1wcyBnbyBi
YWNrd2FyZHMKPiBhZnRlciBjYWNoZSBldmljdGlvbiBvbiBmaWxlc3lzdGVtcyB3aXRoIGxhcmdl
IHRpbWUgZ3JhbnVsYXJpdHk/KQoKQ2xhbXBpbmcgc2VlbXMgdG8gYmUgbmV3IGJlaGF2aW9yIHNp
bmNlIHY1LjQtcmMxLgpCZWZvcmUgdGhhdCBjbGFtcGluZyB3YXMgZG9uZSBpbXBsaWNpdGx5IHdo
ZW4gaGl0dGluZyB0aGUgZGlzayBJSVVDLApzbyBpdCB3YXMgb2JzZXJ2ZWQgbW9zdGx5IGFmdGVy
IGNhY2hlIGV2aWN0aW9uLgoKPgo+IExvb2tzIGxpa2UgZ2VuZXJpYy80MDIgaGFzIG5ldmVyIHJ1
biBpbiBteSB0ZXN0czoKPgo+ICAgICAgICAgZ2VuZXJpYy80MDIgICAgIFtub3QgcnVuXSBubyBr
ZXJuZWwgc3VwcG9ydCBmb3IgeTIwMzggc3lzZnMgc3dpdGNoCj4KClRoZSB0ZXN0IGluIGl0cyBj
dXJyZW50IGZvcm0gaXMgcXVpdGUgcmVjZW50IGFzIHdlbGwgb3IgYXQgdGhlIF9yZXF1aXJlCmhh
cyBjaGFuZ2VkIHJlY2VudGx5LgpTZWUgYWNiMmJhNzggLSBvdmVybGF5OiBzdXBwb3J0IHRpbWVz
dGFtcCByYW5nZSBjaGVjawoKWW91J2QgcHJvYmFibHkgbmVlZCBzb21ldGhpbmcgc2ltaWxhciBm
b3IgbmZzICg/KQoKVGhhbmtzLApBbWlyLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9y
ZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
